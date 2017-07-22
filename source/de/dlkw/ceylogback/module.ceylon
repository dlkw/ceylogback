"A tiny module that allows using Logback as logging backend for the ceylon.logging framework."

native ("jvm")
module de.dlkw.ceylogback "1.2.3" {
    import maven : org.slf4j : "slf4j-api" "1.7.25";
    import maven : ch.qos.logback : "logback-classic" "1.2.3";
    import maven : ch.qos.logback : "logback-core" "1.2.3";

    import ceylon.logging "1.3.2";
}
