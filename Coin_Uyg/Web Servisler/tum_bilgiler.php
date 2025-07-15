<?php 
// Burda tumverilere ulasmak icin post yontemi yerine get yontemi kulanicaz cunku veri almaya gerek yok

//array for JSON response 
$response = array();
//DB_DATABASE,DB_SERVER,DB_PASSWORD,DB_USER degiskeni alinir
require_once __DIR__ . '/db_config.php';
//Baglanti olusturulur
$baglanti=mysqli_connect(DB_SERVER,DB_USER,DB_PASSWORD,DB_DATABASE);
//Baglanti kontrolu yapilir 
if(!$baglanti){
    die("Hatali baglanti : " . mysqli_connect_error());

}
$sqlsorgu = "SELECT * FROM kripto2";
$result = mysqli_query($baglanti,$sqlsorgu);
//result control
if(mysqli_num_rows($result)>0){//Gelen verilerin satir sayisi
    $response["kripto2"] = array();
    while($row = mysqli_fetch_assoc($result)){

        $bilgiler = array();
        $bilgiler["id"]=$row["id"];
        $bilgiler["ad"]=$row["ad"];
        $bilgiler["soyad"]=$row["soyad"];
        $bilgiler["mail"]=$row["mail"];
        $bilgiler["sifre"]=$row["sifre"];
        $bilgiler["bakiye"]=$row["bakiye"];


        array_push($response["kripto2"] , $bilgiler);

    }
    $response["success"]= 1;
    echo json_encode($response);
} else {//Alinan satir olmadigi zaman calisir
    $response["success"]= 0;
    $response["message"]= "No data found ";
    echo json_encode($response);
}
//Baglanti kopar
mysqli_close($baglanti);

?>