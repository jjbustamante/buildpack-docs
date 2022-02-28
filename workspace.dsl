workspace {

    model {

        # Person definition
        developer = person "Developer" "Individual that creates a software or application"
        operator = person "Operator" "IT Person that creates builders to standarize infraestructure in a organization"
        buildpackAuthor = person "Buildpack Authors" "Person or Organization creating and mantaining buildpacks"

        registrySystem = softwareSystem "OCI Registry" "" "storage"
        daemonEngine = softwareSystem "Daemon"
        
        buildpackEnterprise = enterprise "Buildpacks.io" {
            lifecycleSystem = softwareSystem "Lifecycle" {
                !docs docs

                detectorContainer = container "detector" "desc" "executable" "phase"
                analyzerContainer = container "analyzer" "desc" "executable" "phase"
                builderContainer = container "builder" "desc" "executable" "phase"
                exporterContainer = container "exporter" "creates a new OCI image using a combination of remote layers, local layers, and the app directory" "executable" "phase" {
                    -> registrySystem "push/pull oci images to/from"
                    -> daemonEngine "push/pull oci images to/from"
                }
            }   
            builderSystem = softwareSystem "Builder"
            buildpackSystem = softwareSystem "Buildpack"
            platformSystem = softwareSystem "Platform" {
                -> builderSystem "reads and extracts lifecycle executable"
                -> lifecycleSystem "executes it providing the application source code and retrieve the oci image layout when is required"
                -> detectorContainer "executes"
                -> analyzerContainer "executes"
                -> builderContainer "executes"
                -> exporterContainer "executes"
            }
        }

        # Person relationships
        developer -> platformSystem "provides application source code to build an OCI image"
        operator -> builderSystem "creates builders and stacks accoridng to organization needs"
        buildpackAuthor -> buildpackSystem "creates buildpacks for different programming languages (like paketo)"

        # lifecycle relationships
        lifecycleSystem -> registrySystem "push/pull oci images to/from"
        lifecycleSystem -> daemonEngine "push/pull oci images to/from"

        # Builder relationships
        builderSystem -> lifecycleSystem "contains an implementation of"
        builderSystem -> buildpackSystem "contains several"

        # Daemons relationships
        daemonEngine -> registrySystem "push/pull to/from"
    }



    views {

        systemLandscape "System" {
            include *
            animation {

            }
        }

        container lifecycleSystem "Containers" {
            include *
            include platformSystem
            include registrySystem
            include daemonEngine
        }

        styles {
            element "storage" {
                shape cylinder
            }
        }


        theme default
    }


}
