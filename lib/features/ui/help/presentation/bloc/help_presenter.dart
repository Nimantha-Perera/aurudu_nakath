
import 'package:aurudu_nakath/features/ui/help/data/modals/help_topic.dart';
import 'package:aurudu_nakath/features/ui/help/data/repositories/help_repository.dart';

class HelpPresenter {
  final HelpRepository repository;

  HelpPresenter(this.repository);

  List<HelpTopic> getHelpTopics() {
    return repository.getHelpTopics();
  }
}
