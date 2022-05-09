import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/components/dummy_article_tile.dart';
import '../../core/components/headline_with_row.dart';
import '../../core/constants/constants.dart';
import '../../core/controllers/posts/saved_post_controller.dart';
import '../../core/repositories/others/internet_state.dart';
import '../home/home_page/components/internet_not_available.dart';
import 'components/save_list_view.dart';

class SavedPage extends ConsumerStatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends ConsumerState<SavedPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _provider = ref.watch(savedPostController);
    final _notifier = ref.read(savedPostController.notifier);
    final _internetAvailable = ref.watch(internetStateProvider(context));
    if (_internetAvailable) {
      return Container(
        color: Theme.of(context).cardColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDefaults.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeadlineRow(headline: 'saved'),
                _provider.map(
                  data: (data) => Expanded(
                    child: SavedListViewBuilder(
                      data: data.value,
                      listKey: _notifier.animatedListKey,
                      onRefresh: _notifier.onRefresh,
                    ),
                  ),
                  error: (t) => Center(child: Text(t.toString())),
                  loading: (t) => const LoadingSavedArticles(),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return const InternetNotAvailablePage();
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class LoadingSavedArticles extends StatelessWidget {
  const LoadingSavedArticles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16),
        shrinkWrap: true,
        itemBuilder: (context, index) => const DummyArticleTile(),
        itemCount: 5,
      ),
    );
  }
}
