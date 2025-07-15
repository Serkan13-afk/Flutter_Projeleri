<?php 
$response=array();

if (isset($_POST['ad']) && isset($_POST['soyad'])&&isset($_POST['mail']) && isset($_POST['sifre'])&& isset($_POST['bakiye'])){
    $ad=$_POST['ad'];
    $soyad=$_POST['soyad'];
    $mail=$_POST['mail'];
    $sifre=$_POST['sifre'];
    $bakiye=$_POST['bakiye'];

    //DB_SERVER,DB_USER,DB_PASSWORD,DB_DATABASE alinir
    require_once __DIR__ . '/db_config.php';
    //Baglanti olusturuluyor
    $baglanti = mysqli_connect(DB_SERVER,DB_USER,DB_PASSWORD,DB_DATABASE);
    if(!$baglanti){
        die("Hatali baglanti : " .mysqli_connect_error());
    }
    $sqlsorgu = "INSERT INTO kripto2 (ad,soyad,mail,sifre,bakiye) VALUES ('$ad','$soyad','$mail','$sifre','$bakiye')";

    if(mysqli_query($baglanti,$sqlsorgu)){
       $response["success"] = 1;
       $response["message"] = "successfully";
       echo json_encode($response);

    }else{
        $response["success"] = 0;
        $response["message"] = "No product found";
        echo json_encode($response);
    }
    //Baglanti koparilir
    mysqli_close($baglanti);
}
else{
    $response["succes"] = 0;
    $response["message"] = "Required field(s) is missing";
    echo json_encode($response);
}

?>