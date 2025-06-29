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
$sqlsorgu = "SELECT * FROM besinler2";
$result = mysqli_query($baglanti,$sqlsorgu);
//result control
if(mysqli_num_rows($result)>0){//Gelen verilerin satir sayisi
    $response["besinler2"] = array();
    while($row = mysqli_fetch_assoc($result)){

        $besinler = array();
        $besinler["id"]=$row["id"];
        $besinler["ad"]=$row["ad"];
        $besinler["fiyat"]=$row["fiyat"];
        $besinler["resim_url"]=$row["resim_url"];
        $besinler["tur"]=$row["tur"];
        $besinler["aciklama"]=$row["aciklama"];


        array_push($response["besinler2"] , $besinler);

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