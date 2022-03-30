import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/login/dto/experience/experience_info_dto_model.dart';
import 'package:flutter_eb/shared/widgets/custom_text_field/custom_text_field.dart';

class Experience extends StatefulWidget {
  int index;
  ExperienceInfoDTOModel experienceInfoDTOModel;
  Function addCallback, removeCallback;
  Experience(
      {required this.experienceInfoDTOModel,
        required this.addCallback,
        required this.removeCallback,
        required this.index});
  ExperienceState createState() => ExperienceState();
}

class ExperienceState extends State<Experience> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _employmentTypeController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  bool _currentlyWorking = false;
  DateTime selectedStartDate=DateTime.now();
  DateTime selectedEndDate=DateTime.now();
  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  _initializePreferences() async {
    setState(() {
      if(widget.experienceInfoDTOModel.endDate!=""){
        _endDateController.text =
            DateFormat.yMd().format(DateTime.parse(widget.experienceInfoDTOModel.endDate));

      }
      else{
        _endDateController.text=DateFormat.yMd()
            .format(selectedEndDate);
      }
      if(widget.experienceInfoDTOModel.startDate!=""){
        _startDateController.text =
            DateFormat.yMd().format(DateTime.parse(widget.experienceInfoDTOModel.startDate));
      }
      else{
        _startDateController.text=DateFormat.yMd()
        .format(selectedStartDate);
      }
      _titleController =
          TextEditingController(text: widget.experienceInfoDTOModel.company);
      _employmentTypeController = TextEditingController(
          text: widget.experienceInfoDTOModel.employmentType);
      _companyController =
          TextEditingController(text: widget.experienceInfoDTOModel.company);
      _locationController =
          TextEditingController(text: widget.experienceInfoDTOModel.location);
      _descriptionController = TextEditingController(
          text: widget.experienceInfoDTOModel.description);

    });
  }

  void dispose() {
    super.dispose();
    _titleController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _employmentTypeController.dispose();
    _companyController.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10.0,
        ),
        CustomTextFieldForSave(
              (val) {
            widget.experienceInfoDTOModel.company = _titleController.text;
          },
          controller: _titleController,
          labelText: "Title",
          hintText: "Ex: Sales Consultant",

        ),
        CustomTextFieldForSave(
              (val) {
            widget.experienceInfoDTOModel.employmentType =
                _employmentTypeController.text;
          },
          controller: _employmentTypeController,
          labelText: "Employment Type",
          hintText: "Ex: Sales Consultant",

        ),
        CustomTextFieldForSave(
              (val) {
            widget.experienceInfoDTOModel.company = _titleController.text;
          },
          controller: _companyController,
          labelText: "Company",
          hintText: "Ex: Microsoft",

        ),
        CustomTextFieldForSave(
              (val) {
            widget.experienceInfoDTOModel.location = _locationController.text;
          },
          controller: _locationController,
          labelText: "Location",
          hintText: "Ex: London",

        ),
        CustomTextFieldForSave(
              (val) {
            widget.experienceInfoDTOModel.description =
                _descriptionController.text;
          },
          controller: _descriptionController,
          labelText: "Description",
          inputType: TextInputType.multiline,
        ),
        CheckboxListTile(
          value: _currentlyWorking,
          onChanged: (val) {
            setState(() {
              _currentlyWorking = val.toString()=="true";
              widget.experienceInfoDTOModel.currentlyWorking = _currentlyWorking;
            });
          },
          title: Text("I am currently Working in this role"),
        ),
        SizedBox(height: 10.0,),
        Container(alignment:Alignment.topLeft,child: Text("Start Date",textAlign: TextAlign.left,)),
        Container(
            padding: const EdgeInsets.all(5.0),
            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(children: [

              IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        initialDatePickerMode: DatePickerMode.day,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101));
                    if (picked != null) {
                      setState(() {
                        selectedStartDate = picked;
                        _startDateController.text =
                            DateFormat.yMd().format(selectedStartDate);
                        widget.experienceInfoDTOModel.startDate =
                            selectedStartDate.toIso8601String();
                      });
                    }
                  }),
              Text(_startDateController.text),
            ])),
        SizedBox(height: 10.0,),
        _currentlyWorking? Container():Container(alignment:Alignment.topLeft,child: Text("End Date",textAlign: TextAlign.left,)),
        Container(
          padding: const EdgeInsets.all(5.0),
          margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [

              IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _currentlyWorking
                      ? null
                      : () async {
                    final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        initialDatePickerMode: DatePickerMode.day,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2101));
                    if (picked != null) {
                      setState(() {
                        selectedEndDate = picked;
                        _endDateController.text =
                            DateFormat.yMd().format(selectedEndDate);
                        widget.experienceInfoDTOModel.endDate =
                            selectedEndDate.toIso8601String();
                      });
                    }
                  }),
              Text(_endDateController.text),
            ],
          ),
        ),
        /*Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: CustomTextField(
                isEnabled: _currentlyWorking ? false : true,
                controller: _endMonthController,
                labelText: "End Month",
                onSavedCallback: (val) {
                  widget.experienceInfoDTOModel.endMonth =
                      _endMonthController.text;
                },
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.45,
              child: CustomTextField(
                isEnabled: _currentlyWorking ? false : true,
                controller: _endYearController,
                labelText: "End Year",
                onSavedCallback: (val) {
                  widget.experienceInfoDTOModel.endYear =
                      _endYearController.text;
                },
              ),
            ),
          ],
        ),*/
        Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    widget.removeCallback(widget.index);
                  },
                  label: Text(
                    "Remove",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10.0,),
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    int index = widget.index + 1;
                    widget.addCallback(index);
                  },
                  label: Text(
                    "New",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
