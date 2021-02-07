# tester2048
 
Notes:
> Killing dart tasks in terminal:
    taskkill /F /IM dart.exe
> If you have project that was created years ago you need to run this command to update to the latest package
    flutter upgrade then pub get after
    > If you have changes while doing the upgrade it will show you this erorr:
        Your flutter checkout has local changes that would be erased by upgrading. If you want to keep these changes, it is recommended that you stash them via "git stash"
        or else commit the changes to a local branch. If it is okay to remove local changes, then re-run this command with --force.
    > Use the same command with --force:
        flutter upgrade --force then pub get after
    !related links: https://flutter.dev/docs/development/tools/sdk/upgrading
> AnimationController The named parameter 'vsync' isn't defined
    > change this:
        environment:
          sdk: ">=2.8.0 <3.0.0"
        then: flutter pub get
        then: "invalidate the cache and restart" in android studio click (File -> Invalidate Caches/Restart)
    !related links: https://stackoverflow.com/questions/63207206/animationcontroller-the-named-parameter-vsync-isnt-defined