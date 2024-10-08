import 'package:flutter/material.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/constants/constants.dart' as constants;

class ApproveIcon extends StatelessWidget {
  const ApproveIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Icon(Icons.check, color: Colors.green),
      constants.IconToTextGap.vertical,
      Text(S.of(context).save)
    ]);
  }
}

class CancelIcon extends StatelessWidget {
  const CancelIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Icon(Icons.close),
      constants.IconToTextGap.vertical,
      Text(S.of(context).cancel),
    ]);
  }
}

class DeleteIcon extends StatelessWidget {
  const DeleteIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.delete, color: Colors.red),
        constants.IconToTextGap.vertical,
        Text(S.of(context).delete),
      ],
    );
  }
}

class AddIcon extends StatelessWidget {
  const AddIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.add, color: Colors.white),
        constants.IconToTextGap.vertical,
        Text(S.of(context).add),
      ],
    );
  }
}

class SearchIcon extends StatelessWidget {
  const SearchIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.search, color: Colors.red),
        constants.IconToTextGap.vertical,
        Text(S.of(context).search),
      ],
    );
  }
}

class ReportsIcon extends StatelessWidget {
  const ReportsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.report, color: Colors.red),
        constants.IconToTextGap.vertical,
        Text(S.of(context).reports),
      ],
    );
  }
}
