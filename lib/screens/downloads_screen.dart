import 'package:flutter/material.dart';
import '../utils/constants.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  // TODO: Integrate with real downloads data
  final List<String> _downloads = [];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _downloads.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.download_outlined,
                  size: 64,
                  color: AppColors.textHint,
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                Text(
                  AppStrings.noDownloads,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppDimensions.paddingMedium),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to designs tab
                  },
                  child: const Text('Browse & Download'),
                ),
              ],
            )
          : const Text('Downloads content here'),
    );
  }
}
