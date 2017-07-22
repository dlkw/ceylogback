import ceylon.language.meta.declaration {
    Module,
    Package
}
import ceylon.logging {
    Category,
    Priority,
    Logger,
    logger,
    priFatal=fatal,
    priError=error,
    priWarn=warn,
    priInfo=info,
    priDebug=debug,
    priTrace=trace
}

import ch.qos.logback.classic {
    NativeLogbackLogger=Logger,
    Level
}

import org.slf4j {
    Slf4jLogger=Logger,
    LoggerFactory
}

"Configures the ceylon.logging framework to use Logback as its logging backend."
shared void configureLogbackLogging()
{
    logger = (Category c) => CeylonLogbackLogger(c);
}

class CeylonLogbackLogger(category) satisfies Logger
{
    shared actual Category category;

    Priority convertLevel(Level level)
    {
        if (level.levelInt == Level.errorInt) {
            return priError;
        }
        else if (level.levelInt == Level.warnInt) {
            return priWarn;
        }
        else if (level.levelInt == Level.infoInt) {
            return priInfo;
        }
        else if (level.levelInt == Level.debugInt) {
            return priDebug;
        }
        else if (level.levelInt == Level.traceInt) {
            return priTrace;
        }
        else {
            throw AssertionError("unsupported Logger level ``level``");
        }
    }

    Level convertPriority(Priority prio) =>
        switch (prio)
            case (priFatal | priError) Level.error
            case (priWarn) Level.warn
            case (priInfo) Level.info
            case (priDebug) Level.debug
            case (priTrace) Level.trace;

    String loggerName(Category cat) =>
        switch (cat)
            case (is Module) "M``cat.qualifiedName``"
            case (is Package) "P``cat.qualifiedName``";

    Slf4jLogger underlyingLogger = LoggerFactory.getLogger(loggerName(category));

    "The runtime is not configured to use Logback as logging framework."
    assert (is NativeLogbackLogger underlyingLogger);

    // this mostly keeps the ceylon.logging priority and Logback level in sync
    // but fails if the level of the Logback logger is modified directly
    // or if logback watches its configuration file and the value changes there
    variable Priority _priority = convertLevel(underlyingLogger.effectiveLevel);
    shared actual Priority priority => _priority;
    assign priority {
        underlyingLogger.level = convertPriority(priority);
        _priority = priority;
    }

    shared actual void log(Priority priority, String | String() message, Throwable? throwable)
    {
        if (priority < _priority) {
            // the priority is too low to be logged according to configuration
            return;
        }

        String theMessage = switch(message)
            case (is String) message
            case (is String()) message();

        switch (priority)
        case (priFatal) {
            underlyingLogger.error("FATAL: ``theMessage``", throwable);
        }
        case (priError) {
            underlyingLogger.error(theMessage, throwable);
        }
        case (priWarn) {
            underlyingLogger.warn(theMessage, throwable);
        }
        case (priInfo) {
            underlyingLogger.info(theMessage, throwable);
        }
        case (priDebug) {
            underlyingLogger.debug(theMessage, throwable);
        }
        case (priTrace) {
            underlyingLogger.trace(theMessage, throwable);
        }
    }
}
