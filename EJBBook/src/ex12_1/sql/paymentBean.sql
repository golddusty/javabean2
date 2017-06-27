DROP TABLE "PaymentBeanTable";

CREATE TABLE "PaymentBeanTable"
   (
      "_customer_id" INT NOT NULL ,
      "type" CHAR(10),
      "checkBarCode" VARCHAR(50),
      "checkNumber" INT,
      "creditNumber" CHAR(20),
      "creditExpDate" DATE,
      "amount" DECIMAL(10,2)
);
exit;
