load("@rules_jvm_external//:defs.bzl", "maven_install")

ARTIFACTS = [
    "com.fasterxml.jackson.core:jackson-annotations:2.16.1",
    "com.fasterxml.jackson.core:jackson-core:2.16.1",
    "com.fasterxml.jackson.core:jackson-databind:2.16.1",
    "com.github.ben-manes.caffeine:caffeine:2.9.3",
    "com.google.code.findbugs:jsr305:3.0.2",
    "com.google.guava:guava:32.0.1-jre",
    "com.google.guava:failureaccess:1.0.1",
    "com.google.guava:listenablefuture:9999.0-empty-to-avoid-conflict-with-guava",
    "org.checkerframework:checker-qual:3.33.0",
    "com.google.errorprone:error_prone_annotations:2.18.0",
    "com.google.j2objc:j2objc-annotations:2.8",
    "com.nimbusds:nimbus-jose-jwt:9.37.3",
    "com.github.stephenc.jcip:jcip-annotations:1.0-1",
    "commons-codec:commons-codec:1.15",
    "io.airlift:aircompressor:0.27",
    "io.dropwizard.metrics:metrics-core:4.1.22",
    "io.dropwizard.metrics:metrics-jmx:4.1.22",
    "io.dropwizard.metrics:metrics-jvm:4.1.22",
    "io.netty:netty-common:4.1.94.Final",
    "net.bytebuddy:byte-buddy-agent:1.10.19",
    "net.snowflake:snowflake-jdbc:3.16.1",
    "org.apache.commons:commons-compress:1.26.0",
    "commons-io:commons-io:2.15.1",
    "org.apache.commons:commons-configuration2:2.10.1",
    "org.apache.commons:commons-text:1.11.0",
    "org.apache.hadoop:hadoop-common:3.3.6",
    "org.apache.hadoop.thirdparty:hadoop-shaded-protobuf_3_7:1.1.1",
    "org.apache.hadoop:hadoop-annotations:3.3.6",
    "org.apache.hadoop.thirdparty:hadoop-shaded-guava:1.1.1",
    "commons-cli:commons-cli:1.2",
    "org.apache.commons:commons-math3:3.1.1",
    "commons-net:commons-net:3.9.0",
    "commons-collections:commons-collections:3.2.2",
    "jakarta.activation:jakarta.activation-api:1.2.1",
    "commons-beanutils:commons-beanutils:1.9.4",
    "com.google.re2j:re2j:1.1",
    "com.google.code.gson:gson:2.9.0",
    "org.codehaus.woodstox:stax2-api:4.2.1",
    "com.fasterxml.woodstox:woodstox-core:5.4.0",
    "org.apache.parquet:parquet-column:1.13.1",
    "org.apache.parquet:parquet-encoding:1.13.1",
    "org.apache.yetus:audience-annotations:0.13.0",
    "org.apache.parquet:parquet-common:1.13.1",
    "org.apache.parquet:parquet-format-structures:1.13.1",
    "org.apache.parquet:parquet-hadoop:1.13.1",
    "org.apache.parquet:parquet-jackson:1.13.1",
    "commons-pool:commons-pool:1.6",
    "org.bouncycastle:bcpkix-jdk18on:1.78.1",
    "org.bouncycastle:bcutil-jdk18on:1.78.1",
    "org.bouncycastle:bcprov-jdk18on:1.78.1",
    "org.slf4j:slf4j-api:1.7.36",
    "com.github.luben:zstd-jni:1.5.0-1",
    "com.google.protobuf:protobuf-java:3.19.6",
    "org.xerial.snappy:snappy-java:1.1.10.4",
    "junit:junit:4.13.2",
    "org.apache.commons:commons-lang3:3.14.0",
    "org.hamcrest:hamcrest-core:1.3",
    "org.mockito:mockito-core:3.7.7",
    "net.bytebuddy:byte-buddy:1.10.19",
    "org.objenesis:objenesis:3.1",
    "org.powermock:powermock-api-mockito2:2.0.9",
    "org.powermock:powermock-api-support:2.0.9",
    "org.powermock:powermock-core:2.0.9",
    "org.powermock:powermock-reflect:2.0.9",
    "org.javassist:javassist:3.27.0-GA",
    "org.powermock:powermock-module-junit4:2.0.9",
    "org.powermock:powermock-module-junit4-common:2.0.9",
    "org.slf4j:slf4j-simple:1.7.36",
]

EXCLUDED_ARTIFACTS = [
    "ch.qos.reload4j:reload4j",
    "com.github.pjfanning:jersey-json",
    "com.jcraft:jsch",
    "com.sun.jersey:jersey-core",
    "com.sun.jersey:jersey-server",
    "com.sun.jersey:jersey-servlet",
    "dnsjava:dnsjava",
    "javax.activation:activation",
    "javax.servlet:javax.servlet-api",
    "javax.servlet.jsp:jsp-api",
    "org.apache.avro:avro",
    "org.apache.curator:curator-client",
    "org.apache.curator:curator-recipes",
    "org.apache.hadoop:hadoop-auth",
    "org.apache.httpcomponents:httpclient",
    "org.apache.kerby:kerb-core",
    "org.apache.zookeeper:zookeeper",
    "org.eclipse.jetty:jetty-server",
    "org.eclipse.jetty:jetty-servlet",
    "org.eclipse.jetty:jetty-util",
    "org.eclipse.jetty:jetty-webapp",
    "org.slf4j:slf4j-log4j12",
    "org.slf4j:slf4j-reload4j",
    "org.eclipse.aether:aether-util",
]

def snowflake_ingest_java_deps():
    maven_install(
        name = "snowpipe_maven",
        artifacts = ARTIFACTS,
        repositories = [
            "https://repo1.maven.org/maven2",
        ],
        excluded_artifacts = EXCLUDED_ARTIFACTS,
    )

def make_all_unit_tests(srcs, resources, deps, excludes = [], runtime_deps = []):
    native.java_library(
        name = "testlib",
        srcs = srcs,
        resources = resources,
        visibility = ["//visibility:public"],
        deps = deps,
    )

    for src in srcs:
        filename_noext = src.split(".")[0]
        elems = filename_noext.split("/")

        # select test classes that are not explicitly excluded, and ends with Test. Integration tests
        # end with IT but do not currently work under bazel.
        if elems[-1] not in excludes and elems[-1].endswith("Test"):
            clname = ".".join(elems[3:])
            native.java_test(name = clname, test_class = clname, runtime_deps = runtime_deps + [":testlib"], size = "medium")
