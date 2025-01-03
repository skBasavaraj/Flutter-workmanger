# workmanger

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Flutter WorkManger
The key differences between Workmanager().registerOneOffTask() and registerPeriodicTask():
registerOneOffTask():

Executes task only once
Can be scheduled for a specific future time
Better for one-time operations like sending a notification

registerPeriodicTask():

Repeats task at specified intervals
Minimum interval is 15 minutes (Android restriction)
Better for recurring operations like data syncing
