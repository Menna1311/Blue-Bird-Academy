import 'package:cloud_firestore/cloud_firestore.dart';
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
    // final dateFormatted = DateFormat('d MMMM').format(date.toDate());

    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: AppMargin.m8, horizontal: AppMargin.m16),
      padding: const EdgeInsets.all(AppPadding.p16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.s16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                  Icon(
                    Icons.access_time_rounded,
                    color: ColorManager.primary,
                    size: AppSize.s20,
                  ),
                  const SizedBox(width: AppSize.s8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        dayName,
                        style: AppTextStyles.font14W800White(
                          context,
                          color: ColorManager.black,
                          fontSize: AppSize.s14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        timeFormatted,
                        style: AppTextStyles.font14W800White(
                          context,
                          color: Colors.grey.shade600,
                          fontSize: AppSize.s12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSize.s12),

          // Date row
          // Row(
          //   children: [
          //     Icon(
          //       Icons.calendar_today_rounded,
          //       color: ColorManager.primary,
          //       size: AppSize.s18,
          //     ),
          //     const SizedBox(width: AppSize.s8),
          //     Text(
          //       dateFormatted,
          //       style: AppTextStyles.font14W800White(
          //         context,
          //         color: Colors.grey.shade700,
          //         fontSize: AppSize.s14,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ],
          // ),

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
                shadowColor: isUpcoming
                    ? ColorManager.primary.withOpacity(0.3)
                    : Colors.grey,
              ),
              child: Text(
                isUpcoming ? "Mark Attendance" : "View Attendance History",
                style: AppTextStyles.font18W400White(
                  context,
                  color: ColorManager.white,
                  fontSize: AppSize.s16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
