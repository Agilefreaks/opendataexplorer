<?php

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Retrieve form data
    $cautare = escapeshellarg($_POST["cautare"]);
    $result = `grep -rni $cautare /opt/jurnalisti/declaratii/txts |\
    	awk -F ':' '{print $1}' | sed -e 's@.*/@@' -e 's/txt/pdf/' | sort -u`;
    $results = array_filter(explode("\n", $result));
}

?>
<!doctype html>
<html lang=en>
<head>
<meta charset=utf-8>
<title>Cautare declaratii</title>
</head>
<body>
        <form action="cautare.php" method="post">
                <label for="cautare">Cauta:</label>
                <input type="text" id="cautare" name="cautare" required><br><br>
                <input type="submit" value="Cauta">
        </form>

        <p>Rezultate '<?php if( isset($cautare)) {echo $cautare;} ?>'
        	(<?php if (isset($results) && is_array($results)) {echo count($results);} ?>):</p>
        <ul><?php if(isset($results) && is_array($results)) { ?>
        	<?php foreach($results as $pdf) { ?>
                <li><a href="/declaratii-avere/<?php echo $pdf; ?>"><?php echo $pdf; ?></a></li>
        	<?php }?>
        <?php }?>
        </ul>
</body>