# ceylogback
Configure ceylon.logging to use Logback as backend. (JVM runtime only, obviously.)

* Your project must be run with a flat classpath. (Info about how using Logback without flat classpath would be welcome!)
* You must use the JVM parameter `-Dceylon.include.slf4j` (at least for Ceylon 1.3.2).
* Call the toplevel function `configureLogbackLogging()`.
* Normal Logback configuration (`logback.xml` etc.) will take place---put your `logback.xml` into your project's
  `resource/your/project/ROOT` directory.
* Your Ceylon loggers will have a `priority` according to the Logback configuration, and you can assign it a new value.
* This will get out of sync when you modify the level of the Logback loggers directly or change a configuration file that is tracked by the Logback configurator.

Levels are mapped to Priorities with the same names, FATAL is mapped to ERROR with a "FATAL: " message prefix, and ALL and NONE cannot be used.
