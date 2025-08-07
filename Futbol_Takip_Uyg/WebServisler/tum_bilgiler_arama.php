<?php 
$response=array();

if (isset($_POST['tur'])){
    $tur=$_POST['tur'];
    //DB_SERVER,DB_USER,DB_PASSWORD,DB_DATABASE alinir
    require_once __DIR__ . '/db_config.php';
    //Baglanti olusturuluyor
    $baglanti = mysqli_connect(DB_SERVER,DB_USER,DB_PASSWORD,DB_DATABASE);
    if(!$baglanti){
        die("Hatali baglanti : " .mysqli_connect_error());
    }
    $sqlsorgu = "SELECT * FROM takimurlleri3 WHERE takimurlleri3.tur like '%$tur%'";
    $result = mysqli_query($baglanti , $sqlsorgu);

    if(mysqli_num_rows($result) > 0){
     $response["takimurlleri3"] = array();
     while($row = mysqli_fetch_assoc($result)){
        $bilgiler = array();
        $bilgiler["id"] = $row["id"];
        $bilgiler["tur"] = $row["tur"];
        $bilgiler["url"] = $row["url"];

        array_push($response["takimurlleri3"] , $bilgiler);

     }
     $response["success"] = 1;
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