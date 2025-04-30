import 'package:fcomic/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChapterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        var comic = watch.watch(comicSelected);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,

            title: Text('${comic?.name}'),
          ),
          body:
              comic!.chapter.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: comic.chapter.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(comic.chapter[index].name!),
                              ),
                              Divider(thickness: 1,)
                            ],
                          ),
                        );
                      },
                    ),
                  )
                  : Center(child: Text("No Chapters yet.")),
        );
      },
    );
  }
}
