import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:tablets/generated/l10n.dart';
import 'package:tablets/src/common/classes/screen_data_filters.dart';
import 'package:tablets/src/common/interfaces/screen_controller.dart';
import 'package:tablets/src/common/providers/screen_data_notifier.dart';
import 'package:tablets/src/common/values/constants.dart';
import 'package:tablets/src/common/widgets/form_fields/edit_box.dart';
import 'package:tablets/src/common/widgets/custom_icons.dart';

class SearchForm extends StatelessWidget {
  const SearchForm(this._drawerController, this._filterController, this._screenDataController,
      this._screenDataNotifier, this._bodyWidgets,
      {super.key});

  final AnyDrawerController _drawerController;
  final ScreenDataFilters _filterController;
  final ScreenDataController _screenDataController;
  final ScreenDataNotifier _screenDataNotifier;
  final List<Widget> _bodyWidgets;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
        child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._bodyWidgets,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  _screenDataController.setFeatureScreenData(context);
                  final screenData = _screenDataNotifier.data as List<Map<String, dynamic>>;
                  final filteredScreenData = _filterController.applyListFilter(screenData);
                  _screenDataNotifier.set(filteredScreenData);
                },
                icon: const ApproveIcon(),
              ),
              IconButton(
                onPressed: () {
                  _screenDataController.setFeatureScreenData(context);
                  _filterController.reset();
                  _drawerController.close();
                },
                icon: const CancelIcon(),
              ),
            ],
          )
        ],
      ),
    ));
  }
}

class NumberMatchSearchField extends StatelessWidget {
  const NumberMatchSearchField(this._filterController, this._propertyName, this._label,
      {super.key});
  final ScreenDataFilters _filterController;
  final String _propertyName;
  final String _label;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          child: Text(_label),
        ),
        FormInputField(
          initialValue: _filterController.getFilterValue(_propertyName),
          onChangedFn: (value) {
            _filterController.updateFilters(_propertyName, FilterCriteria.equals, value);
          },
          dataType: FieldDataType.num,
          name: _propertyName,
          label: S.of(context).product_code,
        ),
      ],
    );
  }
}
