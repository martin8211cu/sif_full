<!---	instrucciones: 
		ejecutar seccion tres ( inserts lineas 21-600 )
		ejecutar seccion cuatro ( borrar datos 602-614 )
		ejecutar seccion cinco ( inventar nombres 618-670 )
		ejecutar seccion seis ( revisar y borrar tablas temporales 673-682 )

	ESTO SE DEBE EJECUTAR EN UNA COPIA DE MINISIF_SOIN, QUE SE LLAME DIFERENTE
	--->

<cfset DSN=session.dsn><!--- obtiene el datasource--->	

<cfset commit = 0><!--- por default nunca hará commit a menos que se especifique el bit como 1--->
<cfif isdefined("url.commit") and url.commit EQ 1>
	<cfset commit=1>
</cfif>

<cf_dbtemp name="datosEmpleado_temp" returnvariable="datosEmpleado_temp" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
	<cf_dbtempcol name="DEid" 		 	type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="cedula" 		 type="varchar(60)"  	mandatory="no">
	<cf_dbtempcol name="nombre" 		 type="varchar(100)"  	mandatory="no">
	<cf_dbtempcol name="apellido1" 	 type="varchar(80)"		mandatory="no">
	<cf_dbtempcol name="apellido2" 	 type="varchar(80)"		mandatory="no">
</cf_dbtemp>

<cfsetting requesttimeout="#3600*24#">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Creando Empleados ficticios...</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style>
.cajasinbordeb {
	border: 0px none;
	background-color: #FFFFFF;
}
</style>
</head>

<body>

<table width="50%"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr><td>&nbsp;</td></tr>  <tr><td>&nbsp;</td></tr>  <tr><td>&nbsp;</td></tr>  <tr><td>&nbsp;</td></tr>
   <tr>
    	<td><b>Datasource : " <cfoutput>#DSN#</cfoutput> "</b></td>
  </tr>
 <cfif commit eq 0>
  <tr>
    	<td>&nbsp;</td>
  </tr>
     <tr>
    	<td><b>Modo  Prueba</b> : Realizar&aacute; las modificaciones y aplica Rollback</td>
  </tr>
  <cfelse>
  <tr>
    	<td>&nbsp;</td>
  </tr>
     <tr>
    	<td><b>Modo  Commit</b> : Realizar&aacute; las modificaciones y aplicar&aacute; un Commit a la transacci&oacute;n</td>
  </tr>
  </cfif>
  <tr>
    	<td>&nbsp;</td>
  </tr>
  <tr>
    	<td><b>Creando Empleados ficticios...</b></td>
  </tr>
 
  <tr>
    	<td>&nbsp;</td>
  </tr>
  <tr>
		  <td>
				<table width="100%" height="50%"  border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td id="td1" width="1%" height="21" bgcolor="#0099FF" ></td>
					<td id="td2" width = "100%" height="21" ></td>
					<td id="td1" width="1%" height="21" ><input type="text" name="txt1" id="txt1" value="1%" size="3" class="cajasinbordeb"></td>
				</tr>
				</table>	
		</td>
	</tr>
<tr>
<td>&nbsp;</td>
</tr>
</table>

<script language="javascript1.4" type="text/javascript">
	function aumentarStatus(strValor){
		var td1 = document.getElementById("td1");
		var txt1 = document.getElementById("txt1");
		td1.width = strValor;
		txt1.value = strValor;
	}
</script>

<!---
** seccion tres (@nacion)
carga de datos
--->

<cfset tablaAntes = ArrayNew(2)> 

<cftransaction>

<cfset nombres = ArrayNew(1)> 
<cfset nombres[1]="ADOLFO"> 
<cfset nombres[2]= "ADRIAN"> 
<cfset nombres[3]= "ADRIANA"> 
<cfset nombres[4]= "ADRIANA MARIA"> 
<cfset nombres[5]= "ALBERTO"> 
<cfset nombres[6]= "ALEJANDRA"> 
<cfset nombres[7]= "ALEJANDRA MARIA"> 
<cfset nombres[8]= "ALEJANDRO"> 
<cfset nombres[9]= "ALEJANDRO JOSE"> 
<cfset nombres[10]= "ALEXANDER"> 
<cfset nombres[11]= "ALEXANDRA"> 
<cfset nombres[12]= "ALEXIS"> 
<cfset nombres[13]= "ALFONSO"> 
<cfset nombres[14]= "ALFREDO"> 
<cfset nombres[15]= "ALICIA"> 
<cfset nombres[16]= "ALLAN"> 
<cfset nombres[17]= "ALONSO"> 
<cfset nombres[18]= "ALVARO"> 
<cfset nombres[19]= "ALVARO ENRIQUE"> 
<cfset nombres[20]= "ANA"> 
<cfset nombres[21]= "ANA CATALINA"> 
<cfset nombres[22]= "ANA CECILIA"> 
<cfset nombres[23]= "ANA CRISTINA"> 
<cfset nombres[24]= "ANA GABRIELA"> 
<cfset nombres[25]= "ANA ISABEL"> 
<cfset nombres[26]= "ANA LORENA"> 
<cfset nombres[27]= "ANA LUCIA"> 
<cfset nombres[28]= "ANA MARIA"> 
<cfset nombres[29]= "ANA PATRICIA"> 
<cfset nombres[30]= "ANA VICTORIA"> 
<cfset nombres[31]= "ANABELLE"> 
<cfset nombres[32]= "ANDREA"> 
<cfset nombres[33]= "ANDREA MARIA"> 
<cfset nombres[34]= "ANDRES"> 
<cfset nombres[35]= "ANGELA"> 
<cfset nombres[36]= "ANTONIO"> 
<cfset nombres[37]= "ARACELLY"> 
<cfset nombres[38]= "ARMANDO"> 
<cfset nombres[39]= "ARNOLDO"> 
<cfset nombres[40]= "ARTURO"> 
<cfset nombres[41]= "ASDRUBAL"> 
<cfset nombres[42]= "BEATRIZ"> 
<cfset nombres[43]= "BERNAL"> 
<cfset nombres[44]= "BERNARDO"> 
<cfset nombres[45]= "BLANCA ROSA"> 
<cfset nombres[46]= "CARLOS"> 
<cfset nombres[47]= "CARLOS ALBERTO"> 
<cfset nombres[48]= "CARLOS ANDRES"> 
<cfset nombres[49]= "CARLOS EDUARDO"> 
<cfset nombres[50]= "CARLOS ENRIQUE"> 
<cfset nombres[51]= "CARLOS FRANCISCO"> 
<cfset nombres[52]= "CARLOS GERARDO"> 
<cfset nombres[53]= "CARLOS HUMBERTO"> 
<cfset nombres[54]= "CARLOS LUIS"> 
<cfset nombres[55]= "CARLOS MANUEL"> 
<cfset nombres[56]= "CARLOS ROBERTO"> 
<cfset nombres[57]= "CARMEN"> 
<cfset nombres[58]= "CARMEN MARIA"> 
<cfset nombres[59]= "CAROLINA"> 
<cfset nombres[60]= "CATALINA"> 
<cfset nombres[61]= "CECILIA"> 
<cfset nombres[62]= "CESAR"> 
<cfset nombres[63]= "CHRISTIAN"> 
<cfset nombres[64]= "CINDY"> 
<cfset nombres[65]= "CLAUDIA"> 
<cfset nombres[66]= "CLAUDIO"> 
<cfset nombres[67]= "CRISTIAN"> 
<cfset nombres[68]= "CRISTINA"> 
<cfset nombres[69]= "CYNTHIA"> 
<cfset nombres[70]= "DAGOBERTO"> 
<cfset nombres[71]= "DAISY"> 
<cfset nombres[72]= "DAMARIS"> 
<cfset nombres[73]= "DANIEL"> 
<cfset nombres[74]= "DANIELA"> 
<cfset nombres[75]= "DANIELA MARIA"> 
<cfset nombres[76]= "DANILO"> 
<cfset nombres[77]= "DAVID"> 
<cfset nombres[78]= "DENIS"> 
<cfset nombres[79]= "DIANA"> 
<cfset nombres[80]= "DIEGO"> 
<cfset nombres[81]= "DINORAH"> 
<cfset nombres[82]= "DOUGLAS"> 
<cfset nombres[83]= "EDGAR"> 
<cfset nombres[84]= "EDITH"> 
<cfset nombres[85]= "EDUARDO"> 
<cfset nombres[86]= "EDWIN"> 
<cfset nombres[87]= "EFRAIN"> 
<cfset nombres[88]= "ELADIO"> 
<cfset nombres[89]= "ELENA"> 
<cfset nombres[90]= "ELIECER"> 
<cfset nombres[91]= "ELIZABETH"> 
<cfset nombres[92]= "EMILCE"> 
<cfset nombres[93]= "EMILIA MARIA"> 
<cfset nombres[94]= "ENRIQUE"> 
<cfset nombres[95]= "ERIC"> 
<cfset nombres[96]= "ERICK"> 
<cfset nombres[97]= "ERIKA"> 
<cfset nombres[98]= "ERNESTO"> 
<cfset nombres[99]= "ESTEBAN"> 
<cfset nombres[100]= "EVELYN"> 
<cfset nombres[101]= "FABIAN"> 
<cfset nombres[102]= "FABIO"> 
<cfset nombres[103]= "FABIOLA"> 
<cfset nombres[104]= "FANNY"> 
<cfset nombres[105]= "FEDERICO"> 
<cfset nombres[106]= "FELIPE"> 
<cfset nombres[107]= "FERNANDO"> 
<cfset nombres[108]= "FIORELLA"> 
<cfset nombres[109]= "FLOR DE MARIA"> 
<cfset nombres[110]= "FLOR MARIA"> 
<cfset nombres[111]= "FLORA"> 
<cfset nombres[112]= "FLORIBETH"> 
<cfset nombres[113]= "FLORY"> 
<cfset nombres[114]= "FRANCISCO"> 
<cfset nombres[115]= "FRANCISCO JAVIER"> 
<cfset nombres[116]= "FRANCISCO JOSE"> 
<cfset nombres[117]= "FRANKLIN"> 
<cfset nombres[118]= "FREDDY"> 
<cfset nombres[119]= "GABRIEL"> 
<cfset nombres[120]= "GABRIELA"> 
<cfset nombres[121]= "GEINER"> 
<cfset nombres[122]= "GEORGINA"> 
<cfset nombres[123]= "GERARDO"> 
<cfset nombres[124]= "GERARDO ANTONIO"> 
<cfset nombres[125]= "GERARDO ENRIQUE"> 
<cfset nombres[126]= "GERMAN"> 
<cfset nombres[127]= "GILBERT"> 
<cfset nombres[128]= "GILBERTO"> 
<cfset nombres[129]= "GIOVANNI"> 
<cfset nombres[130]= "GISELLE"> 
<cfset nombres[131]= "GLADYS"> 
<cfset nombres[132]= "GLORIANA"> 
<cfset nombres[133]= "GONZALO"> 
<cfset nombres[134]= "GRACE"> 
<cfset nombres[135]= "GRACIELA"> 
<cfset nombres[136]= "GREIVIN"> 
<cfset nombres[137]= "GRETTEL"> 
<cfset nombres[138]= "GUIDO"> 
<cfset nombres[139]= "GUILLERMO"> 
<cfset nombres[140]= "GUISELLE"> 
<cfset nombres[141]= "GUSTAVO"> 
<cfset nombres[142]= "GUSTAVO ADOLFO"> 
<cfset nombres[143]= "HAYDEE"> 
<cfset nombres[144]= "HAZEL"> 
<cfset nombres[145]= "HECTOR"> 
<cfset nombres[146]= "HENRY"> 
<cfset nombres[147]= "HERIBERTO"> 
<cfset nombres[148]= "HERNAN"> 
<cfset nombres[149]= "HILDA"> 
<cfset nombres[150]= "HILDA MARIA"> 
<cfset nombres[151]= "HUGO"> 
<cfset nombres[152]= "HUMBERTO"> 
<cfset nombres[153]= "ILEANA"> 
<cfset nombres[154]= "INGRID"> 
<cfset nombres[155]= "IRENE"> 
<cfset nombres[156]= "IRIS"> 
<cfset nombres[157]= "ISAAC"> 
<cfset nombres[158]= "ISABEL"> 
<cfset nombres[159]= "IVAN"> 
<cfset nombres[160]= "IVANNIA"> 
<cfset nombres[161]= "JACQUELINE"> 
<cfset nombres[162]= "JAIME"> 
<cfset nombres[163]= "JAIRO"> 
<cfset nombres[164]= "JAVIER"> 
<cfset nombres[165]= "JEANNETTE"> 
<cfset nombres[166]= "JENNIFER"> 
<cfset nombres[167]= "JENNY"> 
<cfset nombres[168]= "JESSICA"> 
<cfset nombres[169]= "JESUS"> 
<cfset nombres[170]= "JIMMY"> 
<cfset nombres[171]= "JOHANNA"> 
<cfset nombres[172]= "JOHNNY"> 
<cfset nombres[173]= "JONATHAN"> 
<cfset nombres[174]= "JORGE"> 
<cfset nombres[175]= "JORGE ALBERTO"> 
<cfset nombres[176]= "JORGE ANDRES"> 
<cfset nombres[177]= "JORGE ANTONIO"> 
<cfset nombres[178]= "JORGE ARTURO"> 
<cfset nombres[179]= "JORGE EDUARDO"> 
<cfset nombres[180]= "JORGE ENRIQUE"> 
<cfset nombres[181]= "JORGE LUIS"> 
<cfset nombres[182]= "JOSE"> 
<cfset nombres[183]= "JOSE ALBERTO"> 
<cfset nombres[184]= "JOSE ALFREDO"> 
<cfset nombres[185]= "JOSE ANDRES"> 
<cfset nombres[186]= "JOSE ANGEL"> 
<cfset nombres[187]= "JOSE ANTONIO"> 
<cfset nombres[188]= "JOSE DANIEL"> 
<cfset nombres[189]= "JOSE DAVID"> 
<cfset nombres[190]= "JOSE EDUARDO"> 
<cfset nombres[191]= "JOSE ENRIQUE"> 
<cfset nombres[192]= "JOSE FABIO"> 
<cfset nombres[193]= "JOSE FRANCISCO"> 
<cfset nombres[194]= "JOSE GERARDO"> 
<cfset nombres[195]= "JOSE JOAQUIN"> 
<cfset nombres[196]= "JOSE LUIS"> 
<cfset nombres[197]= "JOSE MANUEL"> 
<cfset nombres[198]= "JOSE MARIA"> 
<cfset nombres[199]= "JOSE MIGUEL"> 
<cfset nombres[200]= "JOSE PABLO"> 
<cfset nombres[201]= "JOSE RAFAEL"> 
<cfset nombres[202]= "JOSUE"> 
<cfset nombres[203]= "JUAN"> 
<cfset nombres[204]= "JUAN BAUTISTA"> 
<cfset nombres[205]= "JUAN CARLOS"> 
<cfset nombres[206]= "JUAN DIEGO"> 
<cfset nombres[207]= "JUAN GABRIEL"> 
<cfset nombres[208]= "JUAN JOSE"> 
<cfset nombres[209]= "JUAN LUIS"> 
<cfset nombres[210]= "JUAN MANUEL"> 
<cfset nombres[211]= "JUAN PABLO"> 
<cfset nombres[212]= "JUAN RAFAEL"> 
<cfset nombres[213]= "JULIETA"> 
<cfset nombres[214]= "JULIO"> 
<cfset nombres[215]= "JULIO CESAR"> 
<cfset nombres[216]= "KAREN"> 
<cfset nombres[217]= "KARINA"> 
<cfset nombres[218]= "KARLA"> 
<cfset nombres[219]= "KARLA VANESSA"> 
<cfset nombres[220]= "KAROL"> 
<cfset nombres[221]= "KATHERINE"> 
<cfset nombres[222]= "KATTIA"> 
<cfset nombres[223]= "KENNETH"> 
<cfset nombres[224]= "LAURA"> 
<cfset nombres[225]= "LAURA MARIA"> 
<cfset nombres[226]= "LAURA PATRICIA"> 
<cfset nombres[227]= "LEONARDO"> 
<cfset nombres[228]= "LEONEL"> 
<cfset nombres[229]= "LETICIA"> 
<cfset nombres[230]= "LIDIA"> 
<cfset nombres[231]= "LIDIETH"> 
<cfset nombres[232]= "LIDIETTE"> 
<cfset nombres[233]= "LIGIA"> 
<cfset nombres[234]= "LIGIA MARIA"> 
<cfset nombres[235]= "LILLIAM"> 
<cfset nombres[236]= "LILLIANA"> 
<cfset nombres[237]= "LORENA"> 
<cfset nombres[238]= "LUCIA"> 
<cfset nombres[239]= "LUCRECIA"> 
<cfset nombres[240]= "LUIS"> 
<cfset nombres[241]= "LUIS ALBERTO"> 
<cfset nombres[242]= "LUIS ALEJANDRO"> 
<cfset nombres[243]= "LUIS ALONSO"> 
<cfset nombres[244]= "LUIS ANGEL"> 
<cfset nombres[245]= "LUIS ANTONIO"> 
<cfset nombres[246]= "LUIS CARLOS"> 
<cfset nombres[247]= "LUIS DIEGO"> 
<cfset nombres[248]= "LUIS EDUARDO"> 
<cfset nombres[249]= "LUIS ENRIQUE"> 
<cfset nombres[250]= "LUIS FELIPE"> 
<cfset nombres[251]= "LUIS FERNANDO"> 
<cfset nombres[252]= "LUIS GERARDO"> 
<cfset nombres[253]= "LUIS GUILLERMO"> 
<cfset nombres[254]= "LUIS GUSTAVO"> 
<cfset nombres[255]= "LUIS ROBERTO"> 
<cfset nombres[256]= "LUZ MARIA"> 
<cfset nombres[257]= "LUZ MARINA"> 
<cfset nombres[258]= "M DE LOS ANGELES"> 
<cfset nombres[259]= "M DEL CARMEN"> 
<cfset nombres[260]= "MAINOR"> 
<cfset nombres[261]= "MANRIQUE"> 
<cfset nombres[262]= "MANUEL"> 
<cfset nombres[263]= "MANUEL ANTONIO"> 
<cfset nombres[264]= "MANUEL ENRIQUE"> 
<cfset nombres[265]= "MARCELA"> 
<cfset nombres[266]= "MARCO ANTONIO"> 
<cfset nombres[267]= "MARCO TULIO"> 
<cfset nombres[268]= "MARCO VINICIO"> 
<cfset nombres[269]= "MARCOS"> 
<cfset nombres[270]= "MARGARITA"> 
<cfset nombres[271]= "MARIA"> 
<cfset nombres[272]= "MARIA ALEJANDRA"> 
<cfset nombres[273]= "MARIA CECILIA"> 
<cfset nombres[274]= "MARIA CRISTINA"> 
<cfset nombres[275]= "MARIA DEL ROCIO"> 
<cfset nombres[276]= "MARIA DEL ROSARIO"> 
<cfset nombres[277]= "MARIA ELENA"> 
<cfset nombres[278]= "MARIA ESTER"> 
<cfset nombres[279]= "MARIA EUGENIA"> 
<cfset nombres[280]= "MARIA FERNANDA"> 
<cfset nombres[281]= "MARIA GABRIELA"> 
<cfset nombres[282]= "MARIA ISABEL"> 
<cfset nombres[283]= "MARIA JOSE"> 
<cfset nombres[284]= "MARIA LAURA"> 
<cfset nombres[285]= "MARIA LUISA"> 
<cfset nombres[286]= "MARIA PAULA"> 
<cfset nombres[287]= "MARIA ROSA"> 
<cfset nombres[288]= "MARIA TERESA"> 
<cfset nombres[289]= "MARIANA"> 
<cfset nombres[290]= "MARIANELA"> 
<cfset nombres[291]= "MARIBEL"> 
<cfset nombres[292]= "MARICELA"> 
<cfset nombres[293]= "MARIELA"> 
<cfset nombres[294]= "MARIO"> 
<cfset nombres[295]= "MARIO ALBERTO"> 
<cfset nombres[296]= "MARIO ENRIQUE"> 
<cfset nombres[297]= "MARISOL"> 
<cfset nombres[298]= "MARITZA"> 
<cfset nombres[299]= "MARJORIE"> 
<cfset nombres[300]= "MARLENE"> 
<cfset nombres[301]= "MARLON"> 
<cfset nombres[302]= "MARTA"> 
<cfset nombres[303]= "MARTA EUGENIA"> 
<cfset nombres[304]= "MARTIN"> 
<cfset nombres[305]= "MARVIN"> 
<cfset nombres[306]= "MAUREEN"> 
<cfset nombres[307]= "MAURICIO"> 
<cfset nombres[308]= "MAYELA"> 
<cfset nombres[309]= "MAYRA"> 
<cfset nombres[310]= "MELISSA"> 
<cfset nombres[311]= "MELVIN"> 
<cfset nombres[312]= "MERCEDES"> 
<cfset nombres[313]= "MICHAEL"> 
<cfset nombres[314]= "MIGUEL"> 
<cfset nombres[315]= "MIGUEL ANGEL"> 
<cfset nombres[316]= "MILENA"> 
<cfset nombres[317]= "MINOR"> 
<cfset nombres[318]= "MIREYA"> 
<cfset nombres[319]= "MIRIAM"> 
<cfset nombres[320]= "MONICA"> 
<cfset nombres[321]= "NANCY"> 
<cfset nombres[322]= "NATALIA"> 
<cfset nombres[323]= "NELLY"> 
<cfset nombres[324]= "NELSON"> 
<cfset nombres[325]= "NIDIA"> 
<cfset nombres[326]= "NOEMY"> 
<cfset nombres[327]= "NORMA"> 
<cfset nombres[328]= "NURIA"> 
<cfset nombres[329]= "OLDEMAR"> 
<cfset nombres[330]= "OLGA"> 
<cfset nombres[331]= "OLGA MARIA"> 
<cfset nombres[332]= "OLGA MARTA"> 
<cfset nombres[333]= "OLGER"> 
<cfset nombres[334]= "OLMAN"> 
<cfset nombres[335]= "OMAR"> 
<cfset nombres[336]= "ORLANDO"> 
<cfset nombres[337]= "OSCAR"> 
<cfset nombres[338]= "OSCAR EDUARDO"> 
<cfset nombres[339]= "OSCAR MARIO"> 
<cfset nombres[340]= "PABLO"> 
<cfset nombres[341]= "PAMELA"> 
<cfset nombres[342]= "PAOLA"> 
<cfset nombres[343]= "PATRICIA"> 
<cfset nombres[344]= "PAULA"> 
<cfset nombres[345]= "PEDRO"> 
<cfset nombres[346]= "PRISCILLA"> 
<cfset nombres[347]= "RAFAEL"> 
<cfset nombres[348]= "RAFAEL ANGEL"> 
<cfset nombres[349]= "RAMON"> 
<cfset nombres[350]= "RANDALL"> 
<cfset nombres[351]= "RAQUEL"> 
<cfset nombres[352]= "RAUL"> 
<cfset nombres[353]= "REBECA"> 
<cfset nombres[354]= "RICARDO"> 
<cfset nombres[355]= "RIGOBERTO"> 
<cfset nombres[356]= "ROBERTO"> 
<cfset nombres[357]= "ROCIO"> 
<cfset nombres[358]= "RODOLFO"> 
<cfset nombres[359]= "RODRIGO"> 
<cfset nombres[360]= "ROGER"> 
<cfset nombres[361]= "ROLANDO"> 
<cfset nombres[362]= "RONALD"> 
<cfset nombres[363]= "RONALD GERARDO"> 
<cfset nombres[364]= "RONNY"> 
<cfset nombres[365]= "ROSA"> 
<cfset nombres[366]= "ROSA MARIA"> 
<cfset nombres[367]= "ROSARIO"> 
<cfset nombres[368]= "ROSIBEL"> 
<cfset nombres[369]= "ROXANA"> 
<cfset nombres[370]= "ROY"> 
<cfset nombres[371]= "RUTH"> 
<cfset nombres[372]= "SANDRA"> 
<cfset nombres[373]= "SANDRA MARIA"> 
<cfset nombres[374]= "SANTIAGO"> 
<cfset nombres[375]= "SARA"> 
<cfset nombres[376]= "SEBASTIAN"> 
<cfset nombres[377]= "SERGIO"> 
<cfset nombres[378]= "SHIRLEY"> 
<cfset nombres[379]= "SILVIA"> 
<cfset nombres[380]= "SILVIA ELENA"> 
<cfset nombres[381]= "SILVIA MARIA"> 
<cfset nombres[382]= "SOFIA"> 
<cfset nombres[383]= "SONIA"> 
<cfset nombres[384]= "SONIA MARIA"> 
<cfset nombres[385]= "STEPHANIE"> 
<cfset nombres[386]= "SUSANA"> 
<cfset nombres[387]= "TATIANA"> 
<cfset nombres[388]= "TERESA"> 
<cfset nombres[389]= "TERESITA"> 
<cfset nombres[390]= "VALERIA"> 
<cfset nombres[391]= "VANESSA"> 
<cfset nombres[392]= "VERONICA"> 
<cfset nombres[393]= "VICTOR"> 
<cfset nombres[394]= "VICTOR HUGO"> 
<cfset nombres[395]= "VICTOR JULIO"> 
<cfset nombres[396]= "VICTOR MANUEL"> 
<cfset nombres[397]= "VILMA"> 
<cfset nombres[398]= "VIRGINIA"> 
<cfset nombres[399]= "VIVIANA"> 
<cfset nombres[400]= "WALTER"> 

<cfset apellidos = ArrayNew(1)> 
<cfset apellidos[1]="ABARCA"> 
<cfset apellidos[2]="ACEVEDO"> 
<cfset apellidos[3]="ACOSTA"> 
<cfset apellidos[4]="ACUNA"> 
<cfset apellidos[5]="AGUERO"> 
<cfset apellidos[6]="AGUILAR"> 
<cfset apellidos[7]="AGUIRRE"> 
<cfset apellidos[8]="ALEMAN"> 
<cfset apellidos[9]="ALFARO"> 
<cfset apellidos[10]="ALPIZAR"> 
<cfset apellidos[11]="ALTAMIRANO"> 
<cfset apellidos[12]="ALVARADO"> 
<cfset apellidos[13]="ALVAREZ"> 
<cfset apellidos[14]="AMADOR"> 
<cfset apellidos[15]="ANCHIA"> 
<cfset apellidos[16]="ANGULO"> 
<cfset apellidos[17]="ARAGON"> 
<cfset apellidos[18]="ARAUZ"> 
<cfset apellidos[19]="ARAYA"> 
<cfset apellidos[20]="ARCE"> 
<cfset apellidos[21]="ARGUEDAS"> 
<cfset apellidos[22]="ARGUELLO"> 
<cfset apellidos[23]="ARIAS"> 
<cfset apellidos[24]="ARRIETA"> 
<cfset apellidos[25]="ARROYO"> 
<cfset apellidos[26]="ARTAVIA"> 
<cfset apellidos[27]="ASTORGA"> 
<cfset apellidos[28]="ASTUA"> 
<cfset apellidos[29]="AVENDANO"> 
<cfset apellidos[30]="AVILA"> 
<cfset apellidos[31]="AZOFEIFA"> 
<cfset apellidos[32]="BADILLA"> 
<cfset apellidos[33]="BALLESTERO"> 
<cfset apellidos[34]="BALTODANO"> 
<cfset apellidos[35]="BARAHONA"> 
<cfset apellidos[36]="BARBOZA"> 
<cfset apellidos[37]="BARQUERO"> 
<cfset apellidos[38]="BARRANTES"> 
<cfset apellidos[39]="BARRIENTOS"> 
<cfset apellidos[40]="BEITA"> 
<cfset apellidos[41]="BEJARANO"> 
<cfset apellidos[42]="BENAVIDES"> 
<cfset apellidos[43]="BERMUDEZ"> 
<cfset apellidos[44]="BERROCAL"> 
<cfset apellidos[45]="BLANCO"> 
<cfset apellidos[46]="BOGANTES"> 
<cfset apellidos[47]="BOLANOS"> 
<cfset apellidos[48]="BONILLA"> 
<cfset apellidos[49]="BORBON"> 
<cfset apellidos[50]="BRAVO"> 
<cfset apellidos[51]="BRENES"> 
<cfset apellidos[52]="BRICENO"> 
<cfset apellidos[53]="BROWN"> 
<cfset apellidos[54]="BUSTAMANTE"> 
<cfset apellidos[55]="BUSTOS"> 
<cfset apellidos[56]="CABEZAS"> 
<cfset apellidos[57]="CALDERON"> 
<cfset apellidos[58]="CALVO"> 
<cfset apellidos[59]="CAMACHO"> 
<cfset apellidos[60]="CAMBRONERO"> 
<cfset apellidos[61]="CAMPOS"> 
<cfset apellidos[62]="CANALES"> 
<cfset apellidos[63]="CARBALLO"> 
<cfset apellidos[64]="CARDENAS"> 
<cfset apellidos[65]="CARMONA"> 
<cfset apellidos[66]="CARRANZA"> 
<cfset apellidos[67]="CARRILLO"> 
<cfset apellidos[68]="CARTIN"> 
<cfset apellidos[69]="CARVAJAL"> 
<cfset apellidos[70]="CASCANTE"> 
<cfset apellidos[71]="CASTILLO"> 
<cfset apellidos[72]="CASTRO"> 
<cfset apellidos[73]="CECILIANO"> 
<cfset apellidos[74]="CEDENO"> 
<cfset apellidos[75]="CENTENO"> 
<cfset apellidos[76]="CERDAS"> 
<cfset apellidos[77]="CERVANTES"> 
<cfset apellidos[78]="CESPEDES"> 
<cfset apellidos[79]="CHACON"> 
<cfset apellidos[80]="CHAN"> 
<cfset apellidos[81]="CHAVARRIA"> 
<cfset apellidos[82]="CHAVERRI"> 
<cfset apellidos[83]="CHAVES"> 
<cfset apellidos[84]="CHINCHILLA"> 
<cfset apellidos[85]="CONEJO"> 
<cfset apellidos[86]="CONTRERAS"> 
<cfset apellidos[87]="CORDERO"> 
<cfset apellidos[88]="CORDOBA"> 
<cfset apellidos[89]="CORELLA"> 
<cfset apellidos[90]="CORRALES"> 
<cfset apellidos[91]="CORTES"> 
<cfset apellidos[92]="COTO"> 
<cfset apellidos[93]="CRUZ"> 
<cfset apellidos[94]="CUBERO"> 
<cfset apellidos[95]="CUBILLO"> 
<cfset apellidos[96]="DAVILA"> 
<cfset apellidos[97]="DELGADO"> 
<cfset apellidos[98]="DIAZ"> 
<cfset apellidos[99]="DUARTE"> 
<cfset apellidos[100]="DURAN"> 
<cfset apellidos[101]="ELIZONDO"> 
<cfset apellidos[102]="ESCALANTE"> 
<cfset apellidos[103]="ESPINOZA"> 
<cfset apellidos[104]="ESQUIVEL"> 
<cfset apellidos[105]="ESTRADA"> 
<cfset apellidos[106]="FAJARDO"> 
<cfset apellidos[107]="FALLAS"> 
<cfset apellidos[108]="FERNANDEZ"> 
<cfset apellidos[109]="FIGUEROA"> 
<cfset apellidos[110]="FLORES"> 
<cfset apellidos[111]="FONSECA"> 
<cfset apellidos[112]="FUENTES"> 
<cfset apellidos[113]="GAMBOA"> 
<cfset apellidos[114]="GARBANZO"> 
<cfset apellidos[115]="GARCIA"> 
<cfset apellidos[116]="GARITA"> 
<cfset apellidos[117]="GARRO"> 
<cfset apellidos[118]="GODINEZ"> 
<cfset apellidos[119]="GOMEZ"> 
<cfset apellidos[120]="GONZALEZ"> 
<cfset apellidos[121]="GRANADOS"> 
<cfset apellidos[122]="GUADAMUZ"> 
<cfset apellidos[123]="GUERRERO"> 
<cfset apellidos[124]="GUEVARA"> 
<cfset apellidos[125]="GUIDO"> 
<cfset apellidos[126]="GUILLEN"> 
<cfset apellidos[127]="GUTIERREZ"> 
<cfset apellidos[128]="GUZMAN"> 
<cfset apellidos[129]="HERNANDEZ"> 
<cfset apellidos[130]="HERRERA"> 
<cfset apellidos[131]="HIDALGO"> 
<cfset apellidos[132]="HUERTAS"> 
<cfset apellidos[133]="JARA"> 
<cfset apellidos[134]="JARQUIN"> 
<cfset apellidos[135]="JIMENEZ"> 
<cfset apellidos[136]="JUAREZ"> 
<cfset apellidos[137]="LACAYO"> 
<cfset apellidos[138]="LARA"> 
<cfset apellidos[139]="LEAL"> 
<cfset apellidos[140]="LEANDRO"> 
<cfset apellidos[141]="LEDEZMA"> 
<cfset apellidos[142]="LEITON"> 
<cfset apellidos[143]="LEIVA"> 
<cfset apellidos[144]="LEON"> 
<cfset apellidos[145]="LIZANO"> 
<cfset apellidos[146]="LOAIZA"> 
<cfset apellidos[147]="LOBO"> 
<cfset apellidos[148]="LOPEZ"> 
<cfset apellidos[149]="LORIA"> 
<cfset apellidos[150]="LUNA"> 
<cfset apellidos[151]="MADRIGAL"> 
<cfset apellidos[152]="MADRIZ"> 
<cfset apellidos[153]="MARCHENA"> 
<cfset apellidos[154]="MARIN"> 
<cfset apellidos[155]="MAROTO"> 
<cfset apellidos[156]="MARTINEZ"> 
<cfset apellidos[157]="MASIS"> 
<cfset apellidos[158]="MATA"> 
<cfset apellidos[159]="MATAMOROS"> 
<cfset apellidos[160]="MATARRITA"> 
<cfset apellidos[161]="MAYORGA"> 
<cfset apellidos[162]="MEDINA"> 
<cfset apellidos[163]="MEJIA"> 
<cfset apellidos[164]="MEJIAS"> 
<cfset apellidos[165]="MELENDEZ"> 
<cfset apellidos[166]="MENA"> 
<cfset apellidos[167]="MENDEZ"> 
<cfset apellidos[168]="MENDOZA"> 
<cfset apellidos[169]="MENESES"> 
<cfset apellidos[170]="MESEN"> 
<cfset apellidos[171]="MEZA"> 
<cfset apellidos[172]="MIRANDA"> 
<cfset apellidos[173]="MOLINA"> 
<cfset apellidos[174]="MONGE"> 
<cfset apellidos[175]="MONTENEGRO"> 
<cfset apellidos[176]="MONTERO"> 
<cfset apellidos[177]="MONTES"> 
<cfset apellidos[178]="MONTIEL"> 
<cfset apellidos[179]="MONTOYA"> 
<cfset apellidos[180]="MORA"> 
<cfset apellidos[181]="MORAGA"> 
<cfset apellidos[182]="MORALES"> 
<cfset apellidos[183]="MOREIRA"> 
<cfset apellidos[184]="MORENO"> 
<cfset apellidos[185]="MORERA"> 
<cfset apellidos[186]="MOYA"> 
<cfset apellidos[187]="MURILLO"> 
<cfset apellidos[188]="MUNOZ"> 
<cfset apellidos[189]="NARANJO"> 
<cfset apellidos[190]="NAVARRO"> 
<cfset apellidos[191]="NUNEZ"> 
<cfset apellidos[192]="OBANDO"> 
<cfset apellidos[193]="OBREGON"> 
<cfset apellidos[194]="OCAMPO"> 
<cfset apellidos[195]="OREAMUNO"> 
<cfset apellidos[196]="OROZCO"> 
<cfset apellidos[197]="ORTEGA"> 
<cfset apellidos[198]="ORTIZ"> 
<cfset apellidos[199]="OTAROLA"> 
<cfset apellidos[200]="OVARES"> 
<cfset apellidos[201]="OVIEDO"> 
<cfset apellidos[202]="PACHECO"> 
<cfset apellidos[203]="PADILLA"> 
<cfset apellidos[204]="PALACIOS"> 
<cfset apellidos[205]="PALMA"> 
<cfset apellidos[206]="PANIAGUA"> 
<cfset apellidos[207]="PARRA"> 
<cfset apellidos[208]="PERALTA"> 
<cfset apellidos[209]="PERAZA"> 
<cfset apellidos[210]="PEREIRA"> 
<cfset apellidos[211]="PEREZ"> 
<cfset apellidos[212]="PENA"> 
<cfset apellidos[213]="PICADO"> 
<cfset apellidos[214]="PIEDRA"> 
<cfset apellidos[215]="PINEDA"> 
<cfset apellidos[216]="PIZARRO"> 
<cfset apellidos[217]="PORRAS"> 
<cfset apellidos[218]="PORTUGUEZ"> 
<cfset apellidos[219]="POVEDA"> 
<cfset apellidos[220]="PRADO"> 
<cfset apellidos[221]="PRENDAS"> 
<cfset apellidos[222]="QUESADA"> 
<cfset apellidos[223]="QUIROS"> 
<cfset apellidos[224]="RAMIREZ"> 
<cfset apellidos[225]="RAMOS"> 
<cfset apellidos[226]="REDONDO"> 
<cfset apellidos[227]="RETANA"> 
<cfset apellidos[228]="REYES"> 
<cfset apellidos[229]="RIOS"> 
<cfset apellidos[230]="RIVAS"> 
<cfset apellidos[231]="RIVERA"> 
<cfset apellidos[232]="ROBLES"> 
<cfset apellidos[233]="RODRIGUEZ"> 
<cfset apellidos[234]="ROJAS"> 
<cfset apellidos[235]="ROLDAN"> 
<cfset apellidos[236]="ROMAN"> 
<cfset apellidos[237]="ROMERO"> 
<cfset apellidos[238]="ROSALES"> 
<cfset apellidos[239]="RUIZ"> 
<cfset apellidos[240]="SABORIO"> 
<cfset apellidos[241]="SAENZ"> 
<cfset apellidos[242]="SALAS"> 
<cfset apellidos[243]="SALAZAR"> 
<cfset apellidos[244]="SANABRIA"> 
<cfset apellidos[245]="SANCHEZ"> 
<cfset apellidos[246]="SANCHO"> 
<cfset apellidos[247]="SANDI"> 
<cfset apellidos[248]="SANDOVAL"> 
<cfset apellidos[249]="SANTAMARIA"> 
<cfset apellidos[250]="SEGURA"> 
<cfset apellidos[251]="SEQUEIRA"> 
<cfset apellidos[252]="SERRANO"> 
<cfset apellidos[253]="SIBAJA"> 
<cfset apellidos[254]="SILES"> 
<cfset apellidos[255]="SILVA"> 
<cfset apellidos[256]="SMITH"> 
<cfset apellidos[257]="SOLANO"> 
<cfset apellidos[258]="SOLERA"> 
<cfset apellidos[259]="SOLIS"> 
<cfset apellidos[260]="SOLORZANO"> 
<cfset apellidos[261]="SOSA"> 
<cfset apellidos[262]="SOTO"> 
<cfset apellidos[263]="SUAREZ"> 
<cfset apellidos[264]="TENCIO"> 
<cfset apellidos[265]="TENORIO"> 
<cfset apellidos[266]="TORRES"> 
<cfset apellidos[267]="TREJOS"> 
<cfset apellidos[268]="UGALDE"> 
<cfset apellidos[269]="ULATE"> 
<cfset apellidos[270]="ULLOA"> 
<cfset apellidos[271]="UMANA"> 
<cfset apellidos[272]="URBINA"> 
<cfset apellidos[273]="URENA"> 
<cfset apellidos[274]="VALENCIANO"> 
<cfset apellidos[275]="VALERIN"> 
<cfset apellidos[276]="VALERIO"> 
<cfset apellidos[277]="VALVERDE"> 
<cfset apellidos[278]="VARELA"> 
<cfset apellidos[279]="VARGAS"> 
<cfset apellidos[280]="VASQUEZ"> 
<cfset apellidos[281]="VEGA"> 
<cfset apellidos[282]="VELASQUEZ"> 
<cfset apellidos[283]="VENEGAS"> 
<cfset apellidos[284]="VILLALOBOS"> 
<cfset apellidos[285]="VILLALTA"> 
<cfset apellidos[286]="VILLARREAL"> 
<cfset apellidos[287]="VILLEGAS"> 
<cfset apellidos[288]="VINDAS"> 
<cfset apellidos[289]="VIQUEZ"> 
<cfset apellidos[290]="ZAMORA"> 
<cfset apellidos[291]="ZAPATA"> 
<cfset apellidos[292]="ZARATE"> 
<cfset apellidos[293]="ZELEDON"> 
<cfset apellidos[294]="ZUMBADO"> 
<cfset apellidos[295]="ZUNIGA"> 
 
<!---
** seccion cuatro (nacion) Borrar Datos
*/--->
	<cfif commit eq 0>
		<cfquery datasource="#DSN#" name="antes">
			INSERT INTO #datosEmpleado_temp# (DEid,cedula,nombre,apellido1,apellido2) 
			SELECT DEid, DEidentificacion,DEnombre, DEapellido1, DEapellido2 from DatosEmpleado
		</cfquery>
	</cfif>
	
<cfquery datasource="#DSN#">
	UPDATE DatosEmpleado
	SET DEnombre = '*', 
		 DEapellido1 = '*', 
		 DEapellido2 = '*', 
		 DEidentificacion = '0', 
		 DEemail = null, 
		 DEtelefono1 = null, 
		 DEtelefono2 = null
</cfquery>

<!--- seccion cinco: inventar datos--->

<cfquery datasource="#DSN#" name="DatosEmpl">
	Select DEid as ident from DatosEmpleado
</cfquery>

<table width="50%"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
  	<td><b>Cantidad de Registros:</b> <cfoutput>#DatosEmpl.RecordCount#</cfoutput></td>
  </tr>
    <tr>
    <td>&nbsp;</td>
  </tr>
	<tr>
    <td><b>Hora de Inicio:</b> <cfoutput>#timeformat(Now(),"HH:mm:ss")#</cfoutput></td>
</tr>
</table>

	
<!---<cfset results = valuelist(DatosEmpl.DEid)>--->
<cfflush interval="1">
<cfloop query="DatosEmpl">	
		<cfset cedula=right(RAND()*7+1,1) & '0' & right('00'& RAND()*1000+1,3) & '0' & right('00'& RAND()*1000+1,3)>
		<cfquery datasource="#DSN#">
			UPDATE DatosEmpleado
			SET 
				DEnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombres[RAND()*400+1]#">,
				DEidentificacion =	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cedula#">,
				DEapellido1 =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#apellidos[RAND()*295+1]#">,
				DEapellido2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#apellidos[RAND()*295+1]#">
			WHERE
				DEid=#ident#
		 </cfquery>
		 
		 <cfoutput>
			<script language="javascript1.4" type="text/javascript">
				aumentarStatus("#iif(Round(DatosEmpl.CurrentRow*100/DatosEmpl.RecordCount) gt 0,Round(DatosEmpl.CurrentRow*100/DatosEmpl.RecordCount),1)#%");
			</script>
		</cfoutput>

</cfloop>

<table width="50%"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
  	<td><b>Hora Final: </b><cfoutput>#timeformat(Now(),"HH:mm:ss")#</cfoutput></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <cfif commit eq 0>
  <tr>
    <td><b><center>Transacci&oacute;n de prueba terminada!</center></b></td>
  </tr> 
    <tr>
    <td>&nbsp;</td>
  </tr> 
    <tr>
    <td><center>Cambio Propuesto:</center></td>
  </tr> 
  <tr>
  		<cfquery name="prueba" datasource="#DSN#">
			SELECT a.DEid,a.DEidentificacion, a.DEnombre, a.DEapellido1, a.DEapellido2 ,
							b.DEid,b.cedula,b.nombre,b.apellido1,b.apellido2
			FROM DatosEmpleado a inner join #datosEmpleado_temp# b 
				ON a.DEid=b.DEid
		</cfquery>
	  <table width="80%"  border="1" align="center" >
	  <tr>
		  <th width="35%" colspan="4">Datos Originales</th>
		  <th width="10%" bordercolor="#FFFFFF"> </th >
		  <th width="35%" colspan="4">Datos Propuestos</th>
	  </tr>
			<tr>
				<th width="20%">Identificaci&oacute;n</th>
				<th width="20%">Nombre</th>
				<th width="20%">Primer Apellido</th>
				<th width="20%">Segundo Apellido</th>
				<th width="20%">Id de Registro</th>
				<th width="20%">Identificaci&oacute;n</th>
				<th width="20%">Nombre</th>
				<th width="20%">Primer Apellido</th>
				<th width="20%">Segundo Apellido</th>
			</tr>
		
|  		<cfoutput query="prueba">
  			<tr>
				 <td>#cedula#</td>
				<td>#nombre#</td>
				<td>#apellido1#</td>
				<td >#apellido2#</td>
				<td align="center" ><u>#DEid#</u></td> 				
				<td>#DEidentificacion#</td>
				<td>#DEnombre#</td>
				<td>#DEapellido1#</td>
				<td >#DEapellido2#</td>
			 </tr>
 	 	</cfoutput>
	 	</table>
   </tr>  
   <cfelse>
   <tr>
    <td><b><center>Transacci&oacute;n Completada Correctamente !</center></b></td>
  </tr> 
  </cfif>
  
  <cfif  commit EQ 0>
  	<cftransaction action="rollback">
  </cfif>
  
 </cftransaction>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>

</body>
</html>

<script language="javascript1.4" type="text/javascript">
	window.close();
</script>