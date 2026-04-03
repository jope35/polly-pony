## Learned User Preferences

- Prefer documentation updates in a polished README style with shields/badges when relevant.
- Prefer documentation claims to stay strictly grounded in repository-backed facts.
- Prefer clear, descriptive script names and consistent reference updates when files are renamed.
- Prefer Python version alignment across all `pyproject.toml` files in the monorepo.

## Learned Workspace Facts

- This workspace is a multi-bundle Databricks repo with `bundle_a`, `bundle_b`, and `bundle_c`.
- The repo has multiple `pyproject.toml` files (root and one per bundle), which are maintained together.
- The workflow includes a root bundle runner script named `run-databricks-bundles.sh`.

## Abbreviations

- DAB: Declarative Automation Bundles
- SDP: Spark Declarative Pipeline
- DLT: Delta Live Tables -> renamed to SDP


## Databricks Docs
# Databricks Documentation
> Comprehensive documentation for the Databricks Data Intelligence Platform, including guides for data engineering, machine learning, AI, analytics, governance, and administration across all supported cloud platforms.

## Overview and getting started
- [Main documentation index](https://docs.databricks.com/) - How-to guides and reference documentation for data teams using the Databricks Data Intelligence Platform to solve analytics and AI challenges in the Lakehouse.
- [What is Databricks?](https://docs.databricks.com/introduction/) - Learn what is the Databricks Data Intelligence Platform.
- [Query and visualize data](https://docs.databricks.com/getting-started/quick-start) - Learn data science basics on Databricks. Using a notebook, query and visualize data stored in Unity Catalog by using SQL, Python, Scala, and R.
- [Import and visualize CSV data from a notebook](https://docs.databricks.com/getting-started/import-visualize-data) - Learn how to import CSV data into a notebook and create visualizations.
- [Create a table](https://docs.databricks.com/getting-started/create-table) - Learn how to create tables in Databricks.
- [Build an ETL pipeline (Lakeflow Spark Declarative Pipelines)](https://docs.databricks.com/getting-started/data-pipeline-get-started) - Learn how to create and deploy an ETL (extract, transform, and load) pipeline with Lakeflow Spark Declarative Pipelines.
- [Build an ETL pipeline (Apache Spark)](https://docs.databricks.com/getting-started/etl-quick-start) - Learn how to build an ETL pipeline using Apache Spark on Databricks.
- [Train and deploy an ML model](https://docs.databricks.com/getting-started/ml-get-started) - Learn how to build a simple machine learning classification model on Databricks using the scikit-learn library.
- [Query LLMs and prototype gen AI agents](https://docs.databricks.com/getting-started/gen-ai-llm-agent) - Learn how to query large language models and prototype generative AI agents on Databricks.
- [Free trial setup](https://docs.databricks.com/getting-started/free-trial) - Learn how to set up a Databricks free trial.
- [Free edition](https://docs.databricks.com/getting-started/free-edition) - Learn how to sign up for Databricks Free Edition and start using Databricks today.

## Core platform
- [Data lakehouse](https://docs.databricks.com/lakehouse/) - Use Databricks in a data lakehouse paradigm for generative AI, ACID transactions, data governance, ETL, BI, and machine learning.
- [Delta Lake](https://docs.databricks.com/delta/) - Learn about the Delta storage protocol used to power the Databricks lakehouse.
- [Unity Catalog](https://docs.databricks.com/data-governance/unity-catalog/) - Learn how to perform data governance in Databricks using Unity Catalog.
- [Catalogs](https://docs.databricks.com/catalogs/) - Learn how to create catalogs in Unity Catalog using Catalog Explorer or SQL statements.
- [Volumes](https://docs.databricks.com/volumes/) - Learn how Unity Catalog volumes govern access to non-tabular data, with managed and external options for different storage needs.
- [Schemas](https://docs.databricks.com/schemas/) - Learn about schemas (databases) in Databricks and how they work in Unity Catalog.
- [OLTP databases](https://docs.databricks.com/oltp/) - Overview of Lakebase, a managed PostgreSQL online transaction processing (OLTP) database for the Databricks platform.
- [Workspace navigation](https://docs.databricks.com/workspace/) - Learn how to navigate a Databricks workspace and access features using the Databricks unified navigation experience.
- [Databricks Assistant](https://docs.databricks.com/notebooks/databricks-assistant-faq) - Understand what Databricks Assistant is and how it can help you code, explore data, and more.
- [Notebooks](https://docs.databricks.com/notebooks/) - Overview of Databricks notebooks for data science, machine learning, and collaborative development.
- [Notebook widgets](https://docs.databricks.com/notebooks/widgets) - Learn how to use input widgets to add parameters to your notebooks and dashboards.
- [Compute resources](https://docs.databricks.com/compute/) - Learn about the types of Databricks compute available in your workspace.
- [Compute configuration reference](https://docs.databricks.com/compute/configure) - Learn about the compute configuration settings available in Databricks.
- [Instance pools](https://docs.databricks.com/compute/pool-index) - Learn what Databricks pools are and how to use them.
- [GPU compute](https://docs.databricks.com/compute/gpu) - Learn about GPU-enabled Databricks compute, when to use them, what they require, and how to create them.
- [Serverless compute](https://docs.databricks.com/compute/serverless/) - On-demand compute without infrastructure management
- [Photon engine](https://docs.databricks.com/runtime/photon) - Learn about Photon, the Databricks native vectorized query engine that runs SQL workloads faster and reduces your total cost per workload.
- [Files](https://docs.databricks.com/files/) - Learn about options for working with files on Databricks.
- [Libraries](https://docs.databricks.com/libraries/) - Learn how to make third-party or custom code available in Databricks using libraries. Learn about the different modes for installing libraries on Databricks.
- [Databricks Runtime](https://docs.databricks.com/release-notes/runtime/) - Explore Databricks runtime releases and maintenance updates for runtime releases.
- [Spark overview](https://docs.databricks.com/spark/) - Find links to resources for working with Apache Spark on Databricks, including DataFrames, streaming, language APIs, and configuration options.

## Data sources and formats
- [Data guides](https://docs.databricks.com/guides/) - Learn how to find, access, and work with data on the Databricks Data Intelligence Platform.
- [Data sources overview](https://docs.databricks.com/query/formats/) - Learn how to use Databricks to query data in the lakehouse and external systems.
- [Tables](https://docs.databricks.com/tables/) - Navigate table types, storage formats, and management features in Databricks.
- [Delta tables](https://docs.databricks.com/tables/delta-table) - Learn about Delta tables and how they are supported on Databricks.
- [Change Data Capture (CDC)](https://docs.databricks.com/delta/delta-change-data-feed) - Learn how to get row-level change information from Delta tables using the Delta change data feed.
- [Apache Iceberg](https://docs.databricks.com/iceberg/) - Learn about the Apache Iceberg table format and how it is supported on Databricks.
- [Managed tables](https://docs.databricks.com/tables/managed) - Learn how to create, query, update, and drop managed tables on Databricks for Delta Lake and Apache Iceberg.
- [External tables](https://docs.databricks.com/tables/external) - Learn how to create, query, update, and drop external tables on Databricks.
- [Delta Sharing](https://docs.databricks.com/query/formats/deltasharing) - Learn how to read shared tables using DataFrames in Databricks.
- [Parquet](https://docs.databricks.com/query/formats/parquet) - Learn how to read data from Apache Parquet files using Databricks.
- [CSV](https://docs.databricks.com/query/formats/csv) - Learn how to read CSV files using Databricks.
- [JSON](https://docs.databricks.com/query/formats/json) - Learn how to read data from JSON files using Databricks.
- [Avro](https://docs.databricks.com/query/formats/avro) - Learn how to read and write data to Avro files using Databricks.
- [ORC](https://docs.databricks.com/query/formats/orc) - Learn how to read data from Apache ORC files using Databricks.
- [XML](https://docs.databricks.com/query/formats/xml) - This article describes how to read and write XML files.
- [Binary files](https://docs.databricks.com/query/formats/binary) - Learn how to read data from binary files using Databricks.
- [Sample datasets](https://docs.databricks.com/discover/databricks-datasets) - Learn how to find and use sample datasets within your existing Databricks workspaces.

## Data engineering
- [Data engineering overview](https://docs.databricks.com/data-engineering/) - Learn about engineering data pipelines with Databricks.
- [Lakeflow Spark Declarative Pipelines](https://docs.databricks.com/ldp/) - Learn about Databricks Lakeflow Spark Declarative Pipelines.
- [Lakeflow Spark Declarative Pipelines concepts](https://docs.databricks.com/ldp/concepts) - Learn what Databricks Lakeflow Spark Declarative Pipelines are and the data processing concepts that define them.
- [Lakeflow Connect](https://docs.databricks.com/ingestion/overview) - Learn about Databricks Lakeflow Connect, which offers efficient connectors to ingest data from enterprise applications, databases, cloud storage, local files, and more.
- [Standard connectors](https://docs.databricks.com/ingestion/) - Learn about the standard connectors in Databricks Lakeflow Connect, which offer higher levels of ingestion pipeline customization compared to the managed connectors.
- [Managed connectors](https://docs.databricks.com/ingestion/lakeflow-connect/) - Learn about how Databricks Lakeflow Connect managed connectors enable you to ingest data from SaaS applications and databases.
- [Lakeflow Spark Declarative Pipelines expectations](https://docs.databricks.com/ldp/expectations) - Learn how to manage data quality in Databricks with expectations for Lakeflow Spark Declarative Pipelines.
- [Structured streaming](https://docs.databricks.com/structured-streaming/concepts) - Learn core concepts for configuring incremental and near real-time workloads with Structured Streaming.
- [Lakeflow Jobs](https://docs.databricks.com/jobs/) - Learn how to orchestrate data processing, machine learning, and data analysis workflows with Lakeflow Jobs.
- [Job tasks](https://docs.databricks.com/jobs/configure-task) - Learn how to create, configure, and edit tasks in Lakeflow Jobs to orchestrate data processing, machine learning, and analytics pipelines.
- [Job scheduling](https://docs.databricks.com/jobs/scheduled) - Learn how to run your Databricks job on a specific schedule.

## Machine learning and AI
- [AI and machine learning overview](https://docs.databricks.com/machine-learning/) - Build AI and machine learning applications on Databricks using unified data and ML platform capabilities.
- [Generative AI](https://docs.databricks.com/generative-ai/agent-framework/build-genai-apps) - Overview of building generative AI apps on Databricks.
- [Agent Bricks](https://docs.databricks.com/generative-ai/agent-bricks/) - Learn how to use Agent Bricks to build and orchestrate domain-specialized AI agents.
- [Agent Framework](https://docs.databricks.com/generative-ai/agent-framework/author-agent) - Build code-first agents using Agent Framework.
- [Foundation model APIs](https://docs.databricks.com/machine-learning/foundation-model-apis) - Learn which options are available to write query requests for supported foundation model types and how to send those requests to a model serving endpoint.
- [AI playground](https://docs.databricks.com/large-language-models/ai-playground) - Chat with supported large language models using Databricks AI Playground available in your Databricks workspace.
- [Serverless GPU compute](https://docs.databricks.com/compute/serverless/gpu) - Use Serverless GPU compute to run large training workloads across GPUs.
- [MLflow for GenAI](https://docs.databricks.com/mlflow3/genai) - Learn how to use MLflow 3 on Databricks to manage the end-to-end lifecycle for GenAI apps.
- [Model registry](https://docs.databricks.com/mlflow/model-registry) - Manage model versions and lifecycle
- [MLflow for Models](https://docs.databricks.com/mlflow/experiments) - Learn how to use MLflow on Databricks to manage the end-to-end lifecycle for classic ML models.
- [Manage models in Unity Catalog](https://docs.databricks.com/machine-learning/manage-model-lifecycle/) - Learn how to manage the lifecycle of MLflow Models in Unity Catalog.
- [Model serving](https://docs.databricks.com/machine-learning/model-serving/) - Learn about Mosaic AI Model Serving and what it offers for ML and generative AI model deployments.
- [AutoML](https://docs.databricks.com/machine-learning/automl/) - Learn about AutoML in Databricks, including its requirements for model training.
- [Feature engineering](https://docs.databricks.com/machine-learning/feature-store/) - Learn about Feature Store and feature engineering in Unity Catalog. Unity Catalog is your feature store, with feature discovery, governance, lineage, and cross-workspace access.
- [Vector search](https://docs.databricks.com/generative-ai/vector-search) - Learn about Mosaic AI Vector Search, a vector search solution built into Databricks and integrated with its governance and productivity tools.
- [Deep learning](https://docs.databricks.com/machine-learning/train-model/deep-learning) - Learn about training deep learning models in Databricks using PyTorch, Tensorflow, TorchDistributor,and DeepSpeed.
- [Distributed training](https://docs.databricks.com/machine-learning/train-model/distributed-training/) - Scale model training across clusters
- [Hyperparameter tuning](https://docs.databricks.com/machine-learning/automl-hyperparam-tuning/) - Optimize model hyperparameters

## SQL and analytics
- [Data warehousing](https://docs.databricks.com/sql/) - Learn about building a data warehousing solution on the Databricks platform using Databricks SQL.
- [SQL warehouses](https://docs.databricks.com/compute/sql-warehouse/) - Learn about using SQL warehouses, formerly called SQL endpoints, for data warehousing on Databricks.
- [Serverless SQL warehouses](https://docs.databricks.com/sql/admin/serverless) - Learn about serverless SQL warehouses and how to manage them.
- [Queries](https://docs.databricks.com/sql/user/queries/) - Learn how to work with query data objects in the Databricks UI.
- [Query history](https://docs.databricks.com/sql/user/queries/query-history) - Learn how to use the query history user interface to troubleshoot query performance.
- [SQL editor](https://docs.databricks.com/sql/user/sql-editor/) - Overview of the features and tools in the DBSQL editor.
- [Metric views](https://docs.databricks.com/metric-views/) - Learn what Unity Catalog metric views are and how to define, govern, and consume them.
- [Dashboards and visualizations](https://docs.databricks.com/dashboards/) - Learn how to share insights with your team using AI/BI dashboards.
- [Alerts](https://docs.databricks.com/sql/user/alerts/) - Learn about using DBSQL alerts to periodically run queries, evaluate defined conditions, and send notifications if a condition is met.
- [AI/BI](https://docs.databricks.com/ai-bi/) - Databricks AI/BI provides self-service data analysis with AI-powered dashboards, conversational Genie spaces, and seamless platform integration.
- [Genie data rooms](https://docs.databricks.com/genie/) - Learn how Genie spaces are used to explore data through a natural language chat interface.
- [Query data](https://docs.databricks.com/query/) - Learn how to query data from the lakehouse and external systems from Databricks.

## Data governance and security
- [Security overview](https://docs.databricks.com/security/) - Learn about how Databricks secures your data and privacy and how you can secure your Databricks account and data.
- [Data governance](https://docs.databricks.com/data-governance/) - Learn about data governance in Databricks.
- [Unity Catalog overview](https://docs.databricks.com/data-governance/unity-catalog/) - Learn how to perform data governance in Databricks using Unity Catalog.
- [Access control](https://docs.databricks.com/security/auth/) - Learn how to manage authentication and access control your Databricks account and workspaces.
- [Access control in Unity Catalog](https://docs.databricks.com/data-governance/unity-catalog/access-control) - Learn how access control works in Unity Catalog, including privileges, ABAC policies, object ownership, and data-level restrictions.
- [Unity Catalog privileges](https://docs.databricks.com/data-governance/unity-catalog/manage-privileges/) - Learn to manage privileges in Unity Catalog, including managing metastore administrators, object ownership, and access to data.
- [Row and column filters](https://docs.databricks.com/data-governance/unity-catalog/filters-and-masks) - Learn how to govern your data at the row and column level using row filters and column masks.
- [Dynamic views](https://docs.databricks.com/data-governance/unity-catalog/create-views) - Learn about Unity Catalog views, temp views, metric views, and dynamic views in Databricks.
- [Data lineage](https://docs.databricks.com/data-governance/unity-catalog/data-lineage) - Learn how to use Unity Catalog to view and analyze data lineage.
- [Audit logging](https://docs.databricks.com/admin/account-settings/audit-logs) - Learn which services and events are recorded in the audit logs.
- [Compliance](https://docs.databricks.com/aws/en/security/privacy/) - Learn how Databricks supports auditing, privacy, and compliance in highly regulated industries, including compliance profiles for HIPAA, IRAP, PCI-DSS, FedRAMP High, and FedRAMP Moderate.
- [Encryption](https://docs.databricks.com/aws/en/security/keys/) - Protect your data with encryption at rest and in-transit. Configure customer-managed keys for more control over your data privacy.
- [Network security](https://docs.databricks.com/security/network/) - Configure secure network connectivity and security controls for Databricks workspaces, compute planes, and data access.
- [Customer-managed keys](https://docs.databricks.com/security/keys/customer-managed-keys) - Manage your own encryption keys.
- [Secret management](https://docs.databricks.com/aws/en/security/secrets/) - Learn about using Databricks secrets to store credentials to authenticate to external data sources through JDBC.

## Specialized features
- [Partner connect](https://docs.databricks.com/partner-connect/) - Third-party integrations
- [Marketplace](https://docs.databricks.com/marketplace/) - Learn how to use the Databricks Marketplace to provide and consume shared data securely.
- [Connect to external sources](https://docs.databricks.com/connect/) - Learn how to connect your Databricks workspace to storage, external data systems, and external cloud services.
- [Clean rooms](https://docs.databricks.com/clean-rooms/) - Learn how to use Clean Rooms, a Databricks feature that provides a secure and privacy-protecting environment where multiple parties can work together on sensitive enterprise data without direct access to each other's data.
- [Delta sharing](https://docs.databricks.com/delta-sharing/) - Learn how to use Delta Sharing for secure data and AI asset sharing with users outside your organization or on different metastores within your Databricks account.
- [Delta sharing recipients](https://docs.databricks.com/delta-sharing/recipient) - Learn how to to access data that has been shared with you using Databricks.

## Administration
- [Administration overview](https://docs.databricks.com/admin/) - Manage your Databricks account, workspaces, users, security, compute resources, and monitor usage across your organization.
- [User and group management](https://docs.databricks.com/admin/users-groups/) - Learn how to manage users, groups, and service principals in Databricks.
- [SCIM provisioning](https://docs.databricks.com/admin/users-groups/scim/) - Learn how to provision users to Databricks using SCIM-enabled IdPs.
- [Service principals](https://docs.databricks.com/admin/users-groups/service-principals) - Learn about using service principals for your Databricks account and workspaces.
- [Personal access tokens](https://docs.databricks.com/dev-tools/auth/pat) - Learn how to set up Databricks authentication by using Databricks personal access tokens (PATs).
- [Workspace settings](https://docs.databricks.com/admin/workspace-settings/) - Learn how to manage Databricks workspace behavior, including storage purges, security headers, and notebook options.
- [Account settings](https://docs.databricks.com/admin/account-settings/) - Learn how to manage account-level Databricks configurations, including user management, workspace creation, and diagnostic logging, and learn when to use the Databricks account console or the Azure portal to manage your account.
- [System tables](https://docs.databricks.com/admin/system-tables/) - Learn how to enable, access, and analyze the data in Databricks system tables.
- [Cost management](https://docs.databricks.com/admin/usage) - Learn about the cost controls and cost monitoring features available on Databricks.
- [Create a workspace](https://docs.databricks.com/admin/workspace/) - Overview of articles concerning workspace creation and management.
- [Create and manage compute policies](https://docs.databricks.com/admin/clusters/policies) - Learn how to use policies that restrict cluster creation capabilities for users and user groups according to a predefined set of rules.

## Developer tools
- [Developer resources](https://docs.databricks.com/developers/) - Learn about Databricks APIs and tools for developing collaborative data science, data engineering, and data analysis solutions in Databricks.
- [REST API](https://docs.databricks.com/api/workspace/introduction) - Complete Databricks REST API reference documentation.
- [SDK for Python](https://docs.databricks.com/dev-tools/sdk-python) - Learn how to use the Databricks SDK for Python to automate Databricks operations using Python.
- [SDK for Java](https://docs.databricks.com/dev-tools/sdk-java) - Learn how to use the Databricks SDK for Java to automate Databricks operations using Java.
- [SDK for Go](https://docs.databricks.com/dev-tools/go-sdk) - Learn how to use the Databricks SDK for Go to automate Databricks operations using Go.
- [Databricks CLI](https://docs.databricks.com/dev-tools/cli/) - Learn about the Databricks CLI, an interface that enables you to work with Databricks from the command-line.
- [Databricks Utilities](https://docs.databricks.com/dev-tools/databricks-utils) - Learn how to use Databricks Utilities in to work with your Databricks environment such as files, object storage, and secrets from notebooks.
- [Git integration](https://docs.databricks.com/repos/) - Learn how to use Git to version control your notebooks and other files for development in Databricks workspaces.
- [GitHub Actions](https://docs.databricks.com/dev-tools/ci-cd/github) - Learn how to use GitHub Actions developed for Databricks in your CI/CD workflows.
- [Databricks Apps](https://docs.databricks.com/dev-tools/databricks-apps/) - Get a conceptual overview of Apps and learn about its main use cases, requirements, and limitations.
- [Declarative Automation Bundles](https://docs.databricks.com/dev-tools/bundles/) - Learn about Declarative Automation Bundles, which enable programmatic management of resources such as jobs, pipelines, and MLOps stacks.
- [Terraform provider](https://docs.databricks.com/dev-tools/terraform/) - Learn how to manage entire Databricks workspaces along with the rest of cloud infrastructure using a flexible, powerful tool.
- [Databricks Connect](https://docs.databricks.com/dev-tools/databricks-connect) -Learn about Databricks Connect. Databricks Connect allows you to connect popular IDEs, notebook servers, and other custom applications to Databricks compute.
- [Visual Studio Code (or Cursor) extension](https://docs.databricks.com/dev-tools/vscode-ext) - Learn about the Databricks extension for Visual Studio Code (or Cursor), which enables you to connect your local development machine to a remote Databricks workspace with just a few clicks.
- [JDBC driver](https://docs.databricks.com/integrations/jdbc-oss/) - Learn how to get started with the open source Databricks JDBC Driver, which enables you to connect participating apps, tools, and SDKs to Databricks through JDBC.
- [ODBC driver](https://docs.databricks.com/integrations/odbc/) - Learn how to get started with the Databricks ODBC Driver, which enables you to connect participating apps, tools, and SDKs to Databricks through ODBC.
- [User-defined functions (UDFs)](https://docs.databricks.com/udf/) - Learn about user-defined functions supported by Databricks and their strengths and limitations.
- [Python UDFs](https://docs.databricks.com/udf/python) - Learn how to implement Python user-defined functions for use from Spark SQL code in Databricks.
- [Scala UDFs](https://docs.databricks.com/udf/scala) - Learn how to implement Scala user-defined functions for use from Spark SQL code in Databricks.
- [Authenticate tools](https://docs.databricks.com/dev-tools/auth/) - Learn how to authorize access to Databricks resources through the Databricks CLI or APIs.

## Reference and language-specific guides
- [Reference overview](https://docs.databricks.com/api) - Reference documentation overview
- [REST API reference](https://docs.databricks.com/api/workspace/introduction) - Complete Databricks REST API reference documentation.
- [Machine readable copy of the REST API reference](https://docs.databricks.com/api/llms.txt) - Machine readable copy of the REST API reference in markdown format intended for consumption by LLMs
- [SQL reference](https://docs.databricks.com/sql/language-manual/) - Learn about the SQL language constructs supported in Databricks SQL.
- [SQL functions](https://docs.databricks.com/sql/language-manual/sql-ref-functions) - Learn about SQL functions in the SQL language constructs supported in Databricks.
- [SQL data types](https://docs.databricks.com/sql/language-manual/sql-ref-datatypes) - Learn about SQL data types in Databricks.
- [CLI reference](https://docs.databricks.com/dev-tools/cli/commands) - Get information about available command groups and commands for the Databricks CLI.
- [Python on Databricks](https://docs.databricks.com/languages/python) - Learn about developing notebooks and jobs in Databricks using the Python language.
- [Scala on Databricks](https://docs.databricks.com/languages/scala) - Learn about developing notebooks and jobs in Databricks using the Scala language.
- [R on Databricks](https://docs.databricks.com/sparkr/) - Learn how to work with Apache Spark from R using SparkR, sparklyr, and RStudio in Databricks.

## Troubleshooting and support
- [Error classes](https://docs.databricks.com/error-messages/error-classes) - Error classes in Databricks
- [Resources](https://docs.databricks.com/resources/) - Learn how to submit support tickets, manage your support contract, submit product feedback, and monitor Databricks system status.
- [Support](https://docs.databricks.com/resources/support) - Learn about Databricks support options, including how to file support tickets in the product or from the Databricks Help Center and how to manage support cases.
- [Status page](https://docs.databricks.com/resources/status) - Learn about the Databricks Status Page, which provides an overview of all core Databricks services.

## Migration and best practices
- [Migration guides](https://docs.databricks.com/migration/) - Learn how to migrate data applications such as ETL jobs, enterprise data warehouses, ML, data science, and analytics to Databricks.
- [Migrate from Apache Spark](https://docs.databricks.com/migration/spark) - Learn the Databricks recommended steps to migrate AS workloads to Databricks.
- [Migrate to Unity Catalog](https://docs.databricks.com/data-governance/unity-catalog/migrate) - Learn how to upgrade tables and views in your Databricks workspace-local Hive metastore to UC.
- [Best practices](https://docs.databricks.com/getting-started/best-practices) - Explore best practice articles to help you make the most out of Databricks.
- [Data engineering best practices](https://docs.databricks.com/data-engineering/best-practices) - Learn about data engineering best practices in Databricks.
- [CI/CD best practices](https://docs.databricks.com/dev-tools/ci-cd/best-practices) - Learn about CI/CD best practices and CI/CD workflows recommended by Databricks.
- [Optimizations](https://docs.databricks.com/optimizations/) - Learn about optimizations and performance recommendations on Databricks.

## Integrations and connectors
- [BI tool integrations](https://docs.databricks.com/integrations/) - Learn how you can connect technology partners to your Databricks workspace so you can use third-party tools with your Databricks lakehouse data.
- [Tableau](https://docs.databricks.com/partners/bi/tableau) - Learn how to use PC to connect from Databricks to Tableau Desktop and how to connect from Tableau Desktop or Tableau Cloud to Databricks.
- [Power BI](https://docs.databricks.com/partners/bi/power-bi) - Learn how to integrate Microsoft Power BI with Databricks for interactive data visualization and business intelligence.
- [Fivetran](https://docs.databricks.com/partners/ingestion/fivetran) - Learn how to set up Databricks to integrate with Fivetran.
- [Apache Kafka](https://docs.databricks.com/structured-streaming/kafka) - Real-time streaming from Kafka
- [Apache Airflow](https://docs.databricks.com/jobs/how-to/use-airflow-with-jobs) - Learn how to orchestrate Lakeflow Jobs in a data pipeline with Apache Airflow and how to set up the Airflow integration.
- [dbt integration](https://docs.databricks.com/partners/prep/dbt) - Learn what is dbt, and how to connect your Databricks workspace to dbt Core, an open-source command line tool that enables data teams to transform data.

## Additional resources
- [Release notes](https://docs.databricks.com/release-notes/) - Learn about Databricks releases for the Databricks platform, the Databricks Runtime, Databricks SQL, Lakeflow Spark Declarative Pipelines, and more.
- [Supported regions](https://docs.databricks.com/resources/supported-regions) - Learn about supported cloud regions.
- [Resource limits](https://docs.databricks.com/resources/limits) - Learn about numerical limits for Databricks resources and whether you can request an increase for each limit.
- [Pricing](https://www.databricks.com/product/pricing) - Databricks pricing information
- [Training and certification](https://www.databricks.com/learn/training) - Official training courses
- [Community forums](https://community.databricks.com/) - Ask questions and share knowledge
- [Knowledge base](https://kb.databricks.com/) - Technical articles and solutions
- [Glossary](https://docs.databricks.com/resources/glossary) - Glossary of key Databricks technical terms.
