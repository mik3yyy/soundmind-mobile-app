import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sound_mind/core/extensions/context_extensions.dart';
import 'package:sound_mind/core/extensions/list_extensions.dart';
import 'package:sound_mind/core/extensions/widget_extensions.dart';
import 'package:sound_mind/core/gen/assets.gen.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:sound_mind/core/routes/routes.dart';
import 'package:sound_mind/features/Authentication/presentation/widgets/question_widget.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<Map<String, String>> questions = [
    {
      'question': 'Little interest or pleasure in doing things?',
      '0': 'Not at all',
      '1': 'Several days',
      '2': 'More than half the days',
      '3': 'Nearly every day',
    },
    {
      'question': 'Feeling down, depressed, or hopeless?',
      '0': 'Not at all',
      '1': 'Several days',
      '2': 'More than half the days',
      '3': 'Nearly every day',
    },
    {
      'question': 'Trouble falling or staying asleep, or sleeping too much?',
      '0': 'Not at all',
      '1': 'Several days',
      '2': 'More than half the days',
      '3': 'Nearly every day',
    },
    {
      'question': 'Feeling tired or having little energy?',
      '0': 'Not at all',
      '1': 'Several days',
      '2': 'More than half the days',
      '3': 'Nearly every day',
    },
    {
      'question': 'Poor appetite or overeating?',
      '0': 'Not at all',
      '1': 'Several days',
      '2': 'More than half the days',
      '3': 'Nearly every day',
    },
    {
      'question':
          'Feeling bad about yourself or that you are a failure or have let yourself or your family down?',
      '0': 'Not at all',
      '1': 'Several days',
      '2': 'More than half the days',
      '3': 'Nearly every day',
    },
    {
      'question':
          'Trouble concentrating on things, such as reading the newspaper or watching television?',
      '0': 'Not at all',
      '1': 'Several days',
      '2': 'More than half the days',
      '3': 'Nearly every day',
    },
    {
      'question':
          'Moving or speaking so slowly that other people could have noticed. Or the opposite being so fidgety or restless that you have been moving around a lot more than usual?',
      '0': 'Not at all',
      '1': 'Several days',
      '2': 'More than half the days',
      '3': 'Nearly every day',
    },
    {
      'question':
          'Thoughts that you would be better off dead, or of hurting yourself?',
      '0': 'Not at all',
      '1': 'Several days',
      '2': 'More than half the days',
      '3': 'Nearly every day',
    },
  ];

  List<int> answers = [];
  int currentPage = 0;
  final PageController _controller = PageController();
  double calculateSeverityScore(List<int> answers) {
    double result = 0;
    for (int i = 0; i < answers.length; i++) {
      result += answers[i].toDouble();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Assets.application.assets.images.logoPurple
              .image(width: 40, height: 40),
          Container(
            width: context.screenWidth,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.colors.greyOutline,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Assets.application.assets.svgs.question.svg(),
                SizedBox(
                  width: context.screenWidth * .75,
                  child: Text(
                    "Over the last 2 weeks, how often have you been bothered by any of the following problems?",
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          FAProgressBar(
            currentValue: currentPage.toDouble() + 1,
            size: 7,
            maxValue: questions.length.toDouble(),
            progressColor: context.primaryColor,
            backgroundColor: context.secondaryColor,
          ),
          Expanded(
            child: QuestionWidget(
              question: questions[currentPage],
              onNext: (answer) {
                if (currentPage == questions.length - 1) {
                  double depressionSeverityScore =
                      calculateSeverityScore(answers);
                  context.pushNamed(Routes.createAccountName,
                      extra: depressionSeverityScore);
                } else {
                  currentPage++;
                  answers.add(answer);
                }

                setState(() {});
              },
            ),
          )
        ].addSpacer(const Gap(20)),
      ).withSafeArea().withCustomPadding(),
    );
  }
}
