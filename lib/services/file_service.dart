import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";
import "package:supa_carbon_icons/supa_carbon_icons.dart";
import "package:url_launcher/url_launcher_string.dart";

/// A service class for handling file-related operations.
///
/// Provides comprehensive utilities for:
/// - Determining file types (office documents, images, videos, PDFs, etc.)
/// - Launching URLs in the default web browser
/// - Creating viewer URLs for office documents and Google Docs
/// - Retrieving appropriate icons for different file types
/// - Managing temporary directories and file operations
///
/// All methods are static, making this a utility class that doesn't require
/// instantiation.
class FileService {
  /// Checks if a file has one of the specified extensions.
  ///
  /// The comparison is case-insensitive. Only the last extension after the
  /// final dot is considered.
  ///
  /// Parameters:
  /// - [filename]: The filename to check (e.g., "document.pdf")
  /// - [extensions]: List of extensions to match against (e.g., ["pdf", "doc"])
  ///
  /// Returns `true` if the file's extension matches any in the list.
  static bool _hasExtension(String filename, List<String> extensions) {
    final extension = filename.split(".").last.toLowerCase();
    return extensions.contains(extension);
  }

  /// Checks if the given filename corresponds to an office file.
  static bool isOfficeFile(String filename) {
    return _hasExtension(
        filename, ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx']);
  }

  /// Checks if the given filename corresponds to a document file.
  static bool isDocFile(String filename) {
    return _hasExtension(filename, ['doc', 'docx']);
  }

  /// Checks if the given filename corresponds to a spreadsheet file.
  static bool isSpreadSheetFile(String filename) {
    return _hasExtension(filename, ['xls', 'xlsx']);
  }

  /// Checks if the given filename corresponds to a presentation file.
  static bool isPresentationFile(String filename) {
    return _hasExtension(filename, ['ppt', 'pptx']);
  }

  /// Checks if the given filename corresponds to an image file.
  static bool isImageFile(String filename) {
    return _hasExtension(filename, ['jpg', 'jpeg', 'png', 'webp', 'bmp']);
  }

  /// Checks if the given filename corresponds to a video file.
  ///
  /// Supports common video formats: mp4, mov, avi, mkv, flv, wmv, webm.
  static bool isVideoFile(String filename) {
    return _hasExtension(
      filename,
      ['mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'webm'],
    );
  }

  /// Checks if the given filename corresponds to a PDF file.
  static bool isPDFFile(String filename) {
    return _hasExtension(filename, ['pdf']);
  }

  /// Launches the specified URL using the default web browser.
  ///
  /// Checks if the URL can be launched before attempting to open it.
  /// If the URL cannot be launched, the method returns silently without
  /// throwing an error.
  ///
  /// Parameters:
  /// - [url]: The URL to launch (must be a valid URL string)
  ///
  /// Throws:
  /// - May throw platform-specific exceptions if URL launching fails.
  static Future<void> launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  /// Creates a URL for viewing an office file using the Microsoft Office web viewer.
  ///
  /// The generated URL can be used to view Office documents (Word, Excel, PowerPoint)
  /// in a web browser without requiring the user to have Office installed.
  ///
  /// Parameters:
  /// - [fileUrl]: The URL of the office file to view
  ///
  /// Returns a formatted URL that can be opened in a web browser to view the document.
  static String createOfficeViewerUrl(String fileUrl) {
    return "https://view.officeapps.live.com/op/view.aspx?src=${Uri.encodeComponent(fileUrl)}";
  }

  /// Creates a URL for viewing a file using the Google Docs web viewer.
  ///
  /// The generated URL can be used to view various document types (PDF, Office files, etc.)
  /// in a web browser using Google's document viewer service.
  ///
  /// Parameters:
  /// - [fileUrl]: The URL of the file to view
  ///
  /// Returns a formatted URL that can be opened in a web browser to view the document.
  static String createGoogleDocsViewerUrl(String fileUrl) {
    return "https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(fileUrl)}";
  }

  /// Retrieves the appropriate icon for the given filename based on its extension.
  ///
  /// Returns a Carbon icon for recognized file types, or a generic attachment icon
  /// for unrecognized types.
  ///
  /// Supported file types with specific icons:
  /// - PDF files: `CarbonIcons.pdf`
  /// - Word documents: `CarbonIcons.doc`
  /// - PowerPoint presentations: `CarbonIcons.ppt`
  /// - Excel spreadsheets: `CarbonIcons.xls`
  /// - ZIP archives: `CarbonIcons.zip`
  /// - Text files: `CarbonIcons.txt`
  /// - Image files: `CarbonIcons.image`
  /// - Other files: `Icons.attachment` (generic)
  ///
  /// Parameters:
  /// - [filename]: The filename to get an icon for
  ///
  /// Returns the appropriate `IconData` for the file type.
  static IconData iconData(String filename) {
    if (_hasExtension(filename, ['pdf'])) {
      return CarbonIcons.pdf;
    }
    if (_hasExtension(filename, ['doc', 'docx'])) {
      return CarbonIcons.doc;
    }
    if (_hasExtension(filename, ['ppt', 'pptx'])) {
      return CarbonIcons.ppt;
    }
    if (_hasExtension(filename, ['xls', 'xlsx'])) {
      return CarbonIcons.xls;
    }
    if (_hasExtension(filename, ['zip'])) {
      return CarbonIcons.zip;
    }
    if (_hasExtension(filename, ['txt'])) {
      return CarbonIcons.txt;
    }
    if (_hasExtension(filename, ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'])) {
      return CarbonIcons.image;
    }
    return Icons.attachment;
  }

  /// Checks if the given filename corresponds to a supported file type.
  ///
  /// Supported file types include:
  /// - Image files: jpg, jpeg, png, gif, bmp, webp
  /// - Office files: doc, docx, xls, xlsx, ppt, pptx
  /// - Video files: mp4, mov, avi, mkv, flv, wmv, webm
  /// - PDF files: pdf
  /// - Archive files: zip
  /// - Text files: txt
  ///
  /// Parameters:
  /// - [filename]: The filename to check
  ///
  /// Returns `true` if the file type is supported, `false` otherwise.
  static bool isSupportedFile(String filename) {
    const supportedExtensions = [
      'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', // Image files
      'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', // Office files
      'mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'webm', // Video files
      'pdf', // PDF files
      'zip', // Zip files
      'txt' // Text files
    ];
    return _hasExtension(filename, supportedExtensions);
  }

  /// Clears all files and directories from the temporary directory.
  ///
  /// This method is only available on non-web platforms. On web, it does nothing.
  /// All files and subdirectories in the temporary directory are deleted recursively.
  /// Errors during deletion are caught and ignored to ensure the process continues
  /// even if some files cannot be deleted.
  ///
  /// Debug prints are used to log the deletion process, showing each file being
  /// deleted and the total count of deleted items.
  static Future<void> clearTempDir() async {
    if (!kIsWeb) {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();
      int i = 0;
      for (final file in files) {
        try {
          debugPrint("Deleting ${file.path}");
          if (file is File || file is Directory) {
            await file.delete(recursive: true);
          }
          i++;
        } catch (_) {
          // Ignore errors during deletion
        }
      }
      debugPrint("Deleted $i files");
    }
  }

  /// Lists all files in the given directory recursively and prints their paths.
  ///
  /// This is a utility method for debugging purposes. It recursively traverses
  /// the directory structure and prints each file's path with an optional prefix.
  ///
  /// Parameters:
  /// - [directory]: The directory to list files from
  /// - [prefix]: Optional prefix to add before each file path in the output (default: "File:")
  static Future<void> listFilesSync(
    Directory directory, {
    String prefix = "File:",
  }) async {
    final files = directory.listSync(recursive: true);
    for (final file in files) {
      debugPrint("$prefix ${file.path}");
    }
  }

  /// Calculates the total size of all files in the given directory.
  ///
  /// Recursively traverses the directory and sums up the size of all files.
  /// Directories themselves are not counted, only the files they contain.
  ///
  /// Parameters:
  /// - [directory]: The directory to calculate the size for
  ///
  /// Returns the total size in bytes as a `double`.
  static Future<double> getDirectorySize(Directory directory) async {
    final files = directory.listSync(recursive: true);
    double size = 0;
    for (final file in files) {
      if (file is File) {
        size += file.lengthSync();
      }
    }
    return size;
  }
}
