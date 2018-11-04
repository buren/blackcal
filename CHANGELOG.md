# Change Log

# v0.5.0

* Add support for builder/DSL pattern
* Rename `start_hour` => `start_time_of_day`
* Rename `finish_hour` => `finish_time_of_day`
* Add attribute readers for `Schedule` data
* Support array of ranges in `DayRange` and `WeeksOfMonthRange`.
* Rename `WeekOfMonthRange` to `WeeksOfMonthRange`
* Support weekday and month numbers - [Fixes #7](https://github.com/buren/blackcal/issues/7)

# v0.4.0

* Add support for weeks of month - [PR #6](https://github.com/buren/blackcal/pull/6)

# v0.3.0

* Minute level resolution support
  - Enhance `Schedule#to_matrix`
  - Enhance `TimeOfDayRange`
  - New `TimeOfDay` class
* Include `Enumerable` in all ranges

# v0.2.0

* Add `Blackcal::schedule`

---

## v0.1.0

Is history..
