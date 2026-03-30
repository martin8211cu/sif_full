<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<!--- ESTO ESTA TUANIX inserta, borra filas a tablas y les agrega columnas --->
<!---
<script type="text/javascript">

function deleteRow(i){
	document.getElementById('myTable').deleteRow(i)
}

function insRow(){

	var input = "<input type=text name=x value=prueba>"

	var x=document.getElementById('myTable').insertRow(0)
	var y=x.insertCell(0)
	var z=x.insertCell(1)
	y.innerHTML="NEW CELL1"
	z.innerHTML=input;
}
</script>
--->

</head>

<body>

<cffunction name="angelica" returntype="struct">
<cfquery name="x" datasource="minisif">
	select * from Empresas
</cfquery>

<cfquery name="y" datasource="minisif">
	select * from SNegocios where Ecodigo=1
</cfquery>

<cfset iloveColo.q1 = x >   
<cfset iloveColo.q2 = y >   

<cfreturn iloveColo >
</cffunction>


<cfset colo = angelica() >
<cfdump var="#colo.q1.Edescripcion#">

<!---<cfinclude template="interfazSoin10.cfm">--->

<!--- ESTO ESTA TUANIX inserta, borra filas a tablas y le s agrega columnas --->
<!---
<table id="myTable" border="1">
<tr>
<td>Row1 cell1</td>
<td>
	<img src="../../imagenes/Borrar01_S.gif" onClick="deleteRow(this.parentNode.parentNode.rowIndex)">
</td>

</tr>
<tr>
<td>Row2 cell1</td>
<td>
	<img src="../../imagenes/Borrar01_S.gif" onClick="deleteRow(this.parentNode.parentNode.rowIndex)">
</td>

</tr>
<tr>
<td>Row3 cell1</td>
<td>
	<img src="../../imagenes/Borrar01_S.gif" onClick="deleteRow(this.parentNode.parentNode.rowIndex)">
</td>

</tr>
<tr>
<td>Row4 cell1</td>
<td>
	<img src="../../imagenes/Borrar01_S.gif" onClick="deleteRow(this.parentNode.parentNode.rowIndex)">
</td>

</tr>
<tr>
<td>Row5 cell1</td>
<td>
	<img src="../../imagenes/Borrar01_S.gif" onClick="deleteRow(this.parentNode.parentNode.rowIndex)">
</td>

</tr>
</table>
<form>
<input type="button" onclick="insRow()" value="Insert row">
</form>
--->






<!---
<cfset CMCid = 48 >
<cfset vCMCid = CMCid >
<cfset jerarquia = '' >

<cfoutput>
<!--- Componente de Seguridad --->
<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

	<cfloop condition="len(trim(vCMCid)) neq 0">
		<cfquery name="dataJefe" datasource="minisif">
			select CMCid, CMCjefe, CMCnombre
			from CMCompradores
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCMCid#">
		</cfquery>
		<cfif len(trim(dataJefe.CMCjefe))>
			<cfset rsJefe = sec.getUsuarioByCod (dataJefe.CMCjefe, 2, 'CMCompradores') >
			<cfset jerarquia = jerarquia & "," & dataJefe.CMCid >
			<cfset vCMCid = rsJefe.llave >
		<cfelse>
			<cfset jerarquia = jerarquia & "," & dataJefe.CMCid >
			<cfbreak>
		</cfif>
	</cfloop>

<cfif len(trim(jerarquia))>
	<cfset jerarquia = mid(jerarquia,2,len(jerarquia)) >
</cfif>

<cfdump var="#jerarquia#">

</cfoutput>
--->

<!---
<form name="form1" method="post" action="prueba.cfm" onSubmit="setTimeout('', 10000); alert('se fue!!')" >

<script type="text/javascript" language="javascript1.2">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisX() {
		var params ="";
		popUpWindow("/cfmx/sif/cm/consultas/ConlisClasificacionArticulo.cfm?formulario=form1&id=Ccodigo&name=Ccodigoclas&nivel=nivel&desc=desc",250,200,650,400);
	}

</script>
--->

<!---
<table border="0" width="100%" cellpadding="0" cellspacing="0">
	<tr><td></td></tr>


	<input type="button" name="prueba" value="prueba" onClick="prueba();">
	
	<script type="text/javascript" language="javascript1.2" >
		function prueba(){
			document.print("HOLA")
		}
	</script>




<!--- ================================================================= --->
<!--- ================================================================= --->
<!--- PRUEBA DE PONER DIRECCIONES EN FAVORITOS --->
<!---<tr><td><input type="button" value="favoritos" name="favoritos" onClick="javascript:favorito();"></td></tr>--->


<!--- ================================================================= --->
<!--- ================================================================= --->
<!--- PRUEBA DE TAG DE ALMACENES --->
<!---<tr><td><cf_sifalmacen size="10" Aid='a' Almcodigo='b' Bdescripcion='c' ></td></tr>--->


<!---
<cfset errores = 0>
<cfloop from="1" to="1000" index="i">
	<cftry>
		<cfquery datasource="sif_pmi_pruebas">
			delete Articulos where Ecodigo=37 and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		</cfquery>
	<cfcatch>
		<cfset errores = errores + 1 >
	</cfcatch>
	</cftry> 
</cfloop>--->

<!---
<cfquery name="rs" datasource="sif_pmi_pruebas">
	select codart, descart
	from temporal
</cfquery>

<cfloop query="rs">
	<cfquery datasource="sif_pmi_pruebas">
		update Articulos
		set Adescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.descart#">,
			Acodalterno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.codart#">
		where Acodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rs.codart)#">
	</cfquery>
</cfloop>
--->
<!---
<cfquery name="rs" datasource="sif_pmi_pruebas" maxrows="6" >
	select Aid from Articulos where Adescripcion like '%RVP%'
</cfquery>

<cfset i = 8.1 >
<cfloop query="rs">
	<cfquery datasource="sif_pmi_pruebas">
		update Articulos
		set Adescripcion = 'CTA ' + <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.Aid#" > + ' RVP ' + <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#" >
		where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.Aid#">
	</cfquery>
	<cfset i = i + 0.3 >
</cfloop>
--->

<!---
<cfset index = 1 >
<cfloop query="rs0">
	<cfquery name="rs" datasource="sif_pmi_pruebas" maxrows="1">
		select Aid, Acodigo, Adescripcion 
		from Articulos 
		where Acodalterno = '92606'
	</cfquery>

	<cfquery datasource="sif_pmi_pruebas">
		update Articulos
		set Adescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs0.descart#">,
			Acodalterno = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs0.codart#">
		where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.Aid#">
	</cfquery>
	<cfset index = rs.CurrentRow >
</cfloop>
--->

<!--- ================================================================= --->
<!--- ================================================================= --->
<!--- PRUEBA DE Fechas con hora --->

<!---
<tr>
	<td> Insertando registro...
		<cfset fecha = '06/09/2004' >
		<cfset vfecha = listtoArray(fecha,'/')>
		<cfset date = CreateDateTime(vfecha[3], vfecha[2], vfecha[1], hour(now()), minute(now()), second(now()) )>
<cfdump var="#date#">


<cfabort>
		<cfquery datasource="sifpublica">
		delete sif_publica..EstadosTracking 
		where ETdescripcion='borrar'
		</cfquery>

		<cfquery name="x" datasource="sifpublica">
			insert EstadosTracking(Ecodigo, ETcodigo, EcodigoASP, CEcodigo, ETdescripcion, Usucodigo, fechaalta, ETorden)
			values (1, 6, 1, 1, 'borrar', 1, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date#">, 1)
		</cfquery>
		
		<CFQUERY name="y" datasource="sifpublica">
		select * from EstadosTracking
		where ETdescripcion='borrar'
		</CFQUERY>
		<cfdump var="#y#">
		
	</td>
</tr>
--->

<!--- ================================================================= --->
<!--- ================================================================= --->
<!--- PRUEBA DE ENTER EN LOS CAMPOS, PARA QUE NO EJECUTE EL SUBMIT --->


<!---<input type="text" size="10" maxlength="10" onBlur="alert('BLUR!!')" onKeyDown="javascript:return capturaTecla(event);" >--->

<!---<input type="text" size="10" maxlength="10" onBlur="x();" >--->

<!--- ================================================================= --->
<!--- ================================================================= --->

<!--- ================================================================= --->
<!--- ================================================================= --->
<!--- PRUEBA DEL CONLIS DE CLASIFICACIONES DE ARTICULOS, PARA QUITARLE LA LISTA --->
<!---
	<input type="text" size="10" name="Ccodigo">
	<input type="text" size="10" name="Ccodigoclas" value="">
	<input type="text" size="10" name="nivel" value="">
	<input type="text" name="desc" size="30">
	<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Clasificaciones de Articulos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisX();'></a>
--->	


<!--- ================================================================= --->

<!--- ================================================================= --->
<!--- ================================================================= --->
<!--- PRUEBA DEL VALUELIST --->
<!---
<cfquery name="x" datasource="#session.dsn#">
	select Ecodigo, Edescripcion from Empresas where Ecodigo=259
</cfquery>

<cfquery name="xx" datasource="#session.dsn#">
	select  Edescripcion from Empresas where Ecodigo in ( <cfif len(trim(ValueList(x.Ecodigo)))>#ValueList(x.Ecodigo)#<cfelse>-1</cfif> )
</cfquery>
--->
<!--- ================================================================= --->


<!--- ================================================================= --->
<!--- ================================================================= --->
<!--- PRUEBA DEL CF por tipo de solicitud y esas varas --->
<!---
<input type="text" name="DSlinea">
<input type="text" name="DCdescprov" size="100">
<input type="text" name="DCcantidad" size="100">
<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Centros Funcionales" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCFuncional();'></a>
--->

<!--- ================================================================= --->
<!--- ================================================================= --->
<!--- PRUEBA DEL TAG DE CLASIFICACIONES DE ARTICULOS --->

<!---<tr><td><cf_sifclasificacionarticulo></td></tr>--->

<!---<tr><td><cf_siftransito></td></tr>--->

<!--- ================================================================= --->
<!--- ================================================================= --->
<!--- PRUEBA DEL SIFARTICULOS CON ALMACENES --->
<!---
<input name="Almacen" type="text" value="34" >
<tr><td><cf_sifarticulos></td></tr>
 --->
 

<!--- ================================================================= --->
<!--- ================================================================= --->
<!--- PRUEBA DEL LEERIMAGEN --->
<!---
<tr><td><cf_sifleerimagen 	autosize="true" 
							border="false"  
							tabla="FMT003" 
							campo="FMT03IMG" 
							condicion="FMT01COD = 'RPFA0003' and FMT03LIN=1"
							conexion="minisif" 
							imgname="xxx" 
							width="80" 
							height="60">
</td></tr>
--->

<!--- ================================================================= --->
<!--- ================================================================= --->
<!--- PRUEBA DEL TAG SNEGOCIOS --->
<!---
	<tr>
		<td width="1%"><strong>Proveedores:</strong></td>
		<td><cf_sifsociosnegocios2 SNtiposocio="P" SNcodigo="x" SNnumero="y" SNnombre="z"  ></td>
	</tr>

	<tr>
		<td width="1%"><strong>Proveedores:</strong></td>
		<td><cf_sifsociosnegocios2 SNtiposocio="P" ></td>
	</tr>


<tr><td><input type="text" size="25" value="kkk" style="border-width:0;" readonly ></td></tr>
--->

<!--- ================================================================= --->
<!--- ================================================================= --->
<!--- PRUEBA DEL TAG RHEMPLEADOS --->
<!---
	<tr>
		<td width="1%"><strong>Empleado:</strong></td>
		<td><cf_rhempleados Usucodigo="usuario" Nombre="nombreu"></td>
	</tr>

	<tr>
		<td width="1%"><strong>Usuario:</strong></td>
		<td><cf_sifusuarioE></td>
	</tr>

	<tr>
		<td><input type="button" name="Ver Datos" value="Ver Datos" onClick="javascript:datos(this.form);"></td>
	</tr>
--->	

<!---
	<tr>
		<td><input type="button" name="Ver Datos" value="Ver Datos" onClick="javascript:datos(this.form);"></td>
	</tr>
--->	

</table>

</form>


<script language="javascript1.2" type="text/javascript">
	function funcAcodigo(){
		alert('sdsd');
	}

	function funcCcodigoclas(){
	alert(document.form1.CAid_Ccodigoclas.value)
	}


	function favorito(){
		//window.external.AddFavorite('http:\\\\www.espn.com','ESPN');
		window.external.AddLinks('http:\\\\www.espn.com','ESPN');
	}

	function capturaTecla(e){
		if(document.all)
			tecla=event.keyCode;
		else{
			tecla=e.which; 
		}
		if(tecla==13){
			alert('enter');
			return false;
		}
	}  
	
	function x(){
		alert(11)
		setTimeout('alert(1)',100000000);
		alert(2)
	}

</script>


<!---
<script language="javascript1.2" type="text/javascript">
	var o = new Object();
	o['ord']= 'rhcp';
	
	for (var i=0; i<11; i++){
		o[i]=i;
	}

	function datos(f){
		alert(o['ord']);
	}

</script>
--->
--->
</body>
</html>

