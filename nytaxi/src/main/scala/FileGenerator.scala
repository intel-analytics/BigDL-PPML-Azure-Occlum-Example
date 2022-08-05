import org.apache.spark.sql.SparkSession

object FileGenerator {
  val spark: SparkSession = SparkSession.builder()
    .master("local[1]")
    .appName("simple-query")
    .getOrCreate()

  def main(args: Array[String]): Unit = {
    val path = FileGenerator.getClass.getResource("").getPath + "people.parquet"
    FileGenerator.parquet(path)
  }

  def parquet(path: String): Unit = {
    val data = Seq(("James ","","Smith","36636","M",3000),
      ("Michael ","Rose","","40288","M",4000),
      ("Robert ","","Williams","42114","M",4000),
      ("Maria ","Anne","Jones","39192","F",4000),
      ("Jen","Mary","Brown","","F",-1))

    val columns = Seq("firstname","middlename","lastname","dob","gender","salary")

    import spark.sqlContext.implicits._
    val df = data.toDF(columns:_*)

    df.write.parquet(path)
  }
}
