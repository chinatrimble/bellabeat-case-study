library(tidyverse)
library (lubridate)
daily1 <- read_csv("dailyActivity_merged.csv")
daily2 <- read_csv("dailyActivity_merged_2.csv")

combined_daily <- rbind(daily1, daily2)
daily <- bind_rows(daily1, daily2)
daily$ActivityDate <- mdy(daily$ActivityDate)
daily_avg <- daily %>%
  group_by(ActivityDate) %>%
  summarize(avg_steps = mean(TotalSteps))
ggplot(daily_avg, aes(x = ActivityDate, y = avg_steps)) + 
  geom_line(color = "#2CB1A6", size = 1.3) + 
  geom_point() + 
  labs(
    title = "Average Daily Steps Over Time",
    x = "Date",
    y = "Average Steps"
  )
ggsave("daily_steps_trend.png")
activity_summary <- daily %>%
  summarize(
    VeryActive = mean(VeryActiveMinutes),
    FairlyActive = mean(FairlyActiveMinutes),
    LightlyActive = mean(LightlyActiveMinutes),
    Sedentary = mean(SedentaryMinutes)
  )
activity_long <- activity_summary %>% 
  pivot_longer(
    cols = everything(),
    names_to = "activity_level",
    values_to = "average_minutes"
  )
ggplot(activity_long, aes(x = activity_level, y = average_minutes)) + geom_col() +
  labs(
    title = "Average Time Spent in Each Activity Level",
    x = "Activity Level",
    y = "Average Minutes"
  )
ggsave("bellabeat_activity_levels.png")
daily$day_of_week <- wday(daily$ActivityDate, label = TRUE)
steps_by_day <- daily %>%
  group_by(day_of_week) %>%
  summarize(avg_steps = mean(TotalSteps))
steps_by_day$day_of_week <- factor(
  steps_by_day$day_of_week,
  levels = c("Sun","Mon", "Tue","Wed","Thu","Fri","Sat")
)
ggplot(steps_by_day, aes(x = day_of_week, y = avg_steps)) + geom_col() + 
  labs(
    title = "User Step Counts Remain Consistent Across the Week",
    x = "Day of Week",
    y = "Average Steps"
  )
ggsave("bellabeat_behavioral_steps_by_day.png")
cor(daily$TotalSteps, daily$SedentaryMinutes, use = "complete.obs")
library(ggplot2)

ggplot(daily, aes(x = TotalSteps, y = SedentaryMinutes)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Relationships Between Steps and Sedentary Time",
    x = "Total Steps",
    y = "Sedentary Minutes"
  )
ggsave("bellabeat_steps_vs_sedentary_relationship.png", width = 8, height = 6)
activity_totals <- data.frame(
  Category = c("Sedentary", "Lightly Active", "Fairly Active","Very Active"),
  Minutes = c(
    mean(combined_daily$SedentaryMinutes),
    mean(combined_daily$LightlyActiveMinutes),
    mean(combined_daily$FairlyActiveMinutes),
    mean(combined_daily$VeryActiveMinutes)
  )
)
ggplot(activity_totals,aes(x = "", y = Minutes, fill = Category)) + 
  geom_bar(stat = "identity", width = 1) + 
  coord_polar("y", start = 0) + 
  
  scale_fill_manual(values = c(
    "Sedentary" = "#2AA6A4",
    "Lightly Active" = "#7ED957",
    "Fairly Active" = "#FFA600",
    "Very Active" = "#8E44AD" 
  )) +
  
  labs(
    title = "Disturbtion of Daily Activity Levels",
    fill = "Activity Type"
    ) + 
  theme_void()
ggsave("bellabeat_activity_distrubtion.png")
ggplot(combined_daily,aes(x = TotalSteps, y = Calories)) + 
  geom_point(alpha = 0.4) + 
  geom_smooth(method = "lm", color = "#2CB1A6",se = FALSE) + 
  labs(
    title = "Daily Steps vs. Calories",
    x = "Total Daily Steps",
    y = "Calories Burned"
  ) + 
  theme_minimal()
ggsave("bellabeat_steps_vs_calories.png")