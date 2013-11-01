<?php
	$configPath = 'config.xml';
	// Считываем содержимое файла
	$file = fopen ( $configPath , 'r' );
	$fileContent = fread ( $file , filesize ( $configPath ) );
	fclose ( $file );
	
	// Заменяем значение параметров
	foreach ( $_POST as $parameter => $value ) {
		$pattern = '/name="'.$parameter.'".*value="[^"]*/';
		$replacement = "name=\"$parameter\" \t value=\"$value";
		$fileContent = preg_replace($pattern, $replacement, $fileContent);
	}

	// Записываем изменения в файл
	$file = fopen ( $configPath , 'w+' );
	fputs ( $file , $fileContent );
	fclose ( $file );
?>