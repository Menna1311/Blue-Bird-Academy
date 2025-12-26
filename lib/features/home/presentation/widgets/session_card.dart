import 'package:blue_bird/utils/strings_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:blue_bird/utils/color_manager.dart';
import 'package:blue_bird/utils/text_styles.dart';
import 'package:blue_bird/utils/values_manager.dart';

class SessionCard extends StatelessWidget {
  final String dayName;
  final Timestamp date;
  final Timestamp time;
  final String status;
  final bool isUpcoming;
  final VoidCallback onPressed;

  const SessionCard({
    super.key,
    required this.dayName,
    required this.date,
    required this.time,
    required this.status,
    required this.isUpcoming,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormatted = DateFormat('HH:mm').format(time.toDate());

    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: AppMargin.m8, horizontal: AppMargin.m16),
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.s16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: AppSize.s8,
            offset: const Offset(0, AppSize.s4),
          ),
        ],
        border: Border.all(
          color: isUpcoming
              ? ColorManager.primary.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
          width: AppSize.s1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status + time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p12, vertical: AppPadding.p8),
                decoration: BoxDecoration(
                  color: isUpcoming
                      ? ColorManager.primary.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSize.s20),
                  border: Border.all(
                    color: isUpcoming ? ColorManager.primary : Colors.grey,
                    width: AppSize.s1,
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isUpcoming
                        ? ColorManager.primary
                        : Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: AppSize.s14,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded,
                      color: ColorManager.primary, size: AppSize.s20),
                  const SizedBox(width: AppSize.s8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(dayName,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: AppSize.s14,
                          )),
                      Text(timeFormatted,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
                            fontSize: AppSize.s12,
                          )),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSize.s16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isUpcoming ? ColorManager.primary : Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.p14, horizontal: AppPadding.p20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s12),
                ),
                elevation: AppSize.s2,
              ),
              child: Text(
                isUpcoming
                    ? StringsManager.markAttendance.tr()
                    : StringsManager.viewAttendanceHistory.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: AppSize.s16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
