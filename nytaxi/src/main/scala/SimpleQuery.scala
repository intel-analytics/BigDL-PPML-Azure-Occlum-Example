import java.util.Date

import org.apache.spark.sql.SparkSession

object SimpleQuery {
  val spark: SparkSession = SparkSession.builder()
    .master("local[1]")
    .appName("simple-query")
    .getOrCreate()

  def main(args: Array[String]): Unit = {
    val blobAccountName = sys.env.getOrElse("AZURE_BLOB_ACCOUNT_NAME", "")
    val blobContainerName = sys.env.getOrElse("AZURE_BLOB_CONTAINER_NAME", "")
    val blobRelativePath = sys.env.getOrElse("AZURE_BLOB_RELATIVE_PATH", "")
    val blobSasToken = sys.env.getOrElse("AZURE_BLOB_SAS_TOKEN", "")
    val azureSqlAeJdbc = sys.env.getOrElse("AZURE_SQL_AE_JDBC", "")


    println("########################################")
    println("############### COUNT * ################")
    println("########################################")
    val startTime = new Date().getTime
    val path = FileGenerator.getClass.getResource("").getPath + "people.parquet"
    val parquetDF = spark.read.parquet(path)
    println("Input DataFrame Count: " + parquetDF.count())
    val endTime = new Date().getTime
    println("Aggregation duration: " + (endTime - startTime))
  }
}
