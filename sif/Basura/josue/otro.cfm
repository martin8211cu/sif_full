<!---
<cfquery name="data" datasource="minisif">
	select a.DEid, a.RHPcodigo, 1, balanceado, introvertido, extravertido, BRval, BLval, FRval, FLval, BRtol, BLtol, FRtol, FLtol, 27, getdate()
	from LineaTiempo a
	
	inner join RHPuestos b
	on a.Ecodigo=b.Ecodigo
	and a.RHPcodigo=b.RHPcodigo
	
	where getdate() between LTdesde and LThasta
	and a.Ecodigo=1
	and DEid not in (select DEid from PerfilUsuarioB) 
</cfquery>

<cfoutput query="data">
	<cfset xbr_val = (data.BRval * data.BRtol)/100 >
	<cfset xbl_val = (data.BLval * data.BLtol)/100 >
	<cfset xfr_val = (data.FRval * data.FRtol)/100 >
	<cfset xfl_val = (data.FLval * data.FLtol)/100 >

	<cfset brop = RandRange(1,2)>
	<cfset blop = RandRange(1,2)>
	<cfset frop = RandRange(1,2)>
	<cfset flop = RandRange(1,2)>

	<cfif brop eq 1>
		<cfset br_val = data.BRval + xbr_val >
	<cfelse>
		<cfset br_val = data.BRval - xbr_val >
	</cfif>

	<cfif blop eq 1>
		<cfset bl_val = data.BLval + xbl_val >
	<cfelse>
		<cfset bl_val = data.BLval - xbl_val >
	</cfif>

	<cfif frop eq 1>
		<cfset fr_val = data.BRval + xfr_val >
	<cfelse>
		<cfset fr_val = data.BRval - xfr_val >
	</cfif>

	<cfif flop eq 1>
		<cfset fl_val = data.BLval + xfl_val >
	<cfelse>
		<cfset fl_val = data.BLval - xfl_val >
	</cfif>

		<!--- - --->
		<CFQUERY datasource="minisif">
			insert PerfilUsuarioB(	DEid, 
									RHPcodigo, 
									Ecodigo, 
									balanceado, 
									introvertido, 
									extravertido, 
									BRval, 
									BLval, 
									FRval, 
									FLval, 
									BMUsucodigo, 
									fechaalta)	
			values ( 	#data.DEid#,
						'#data.RHPcodigo#',
						1,
						#data.balanceado#,
						#data.introvertido#,
						#data.extravertido#,
						#ceiling(BR_val)#,
						#ceiling(BL_val)#,
						#ceiling(FR_val)#,
						#ceiling(FL_val)#,
						27,
						getdate()
			)
		</CFQUERY>

<!---
	<cfset fr = ceiling(RandRange(40,80)/10)>
	<cfset bl = ceiling(RandRange(50,100)/10)>
	<cfset br = ceiling(RandRange(20,70)/10)>
	<cftransaction>
	<cfquery datasource="minisif">
		update RHPuestos
		set FLtol=#fl#, 
			FRtol=#fr#, 
			BLtol=#bl#, 
			BRtol=#br# 
		where Ecodigo=1
		  and RHPcodigo = '#data.RHPcodigo#'
	</cfquery>
	</cftransaction>
--->	
</cfoutput>
--->		


<!---
<form name="form1">
	<cf_sifeditorhtml name='x'>
<input type="button" value="XXX" name="XXX" onClick="javascript:prueba()">
</form>

<script  language="javascript1.2" type="text/javascript">
	function prueba(){
		var y = document.form1.x
		alert(y.value)
	}
</script>
--->

<!---
<cfset matriz = ArrayNew(1) >
<cfset registros = 8 >
<cfset columnas = 7 >

<!--- Arreglo bidimensional --->
<cfloop from="1" to="#registros#" index="i">
	<cfloop from="1" to="#columnas#" index="j">
		<cfset matriz[i][j] = '#i#-#j#' >
	</cfloop>
</cfloop>

<!--- Arreglo unidimensional con una estructura por cada entrada --->
<cfloop from="1" to="#registros#" index="i">
	<cfset matriz[i] = structNew() >
	<cfset matriz[i].campo1 = '#i#-#j# c1' >
	<cfset matriz[i].campo2 = '#i#-#j# c2' >
	<cfset matriz[i].campo3 = '#i#-#j# c3' >
	<cfset matriz[i].campo4 = '#i#-#j# c4' >
	<cfset matriz[i].campo5 = '#i#-#j# c5' >
	<cfset matriz[i].campo6 = '#i#-#j# c6' >
	<cfset matriz[i].campo7 = '#i#-#j# c7' >
</cfloop>

<!--- Insertar array--->
<cfset tmp.dato1 = 'INSERTAR'>
<cfset ArrayInsertAt(matriz, 5, tmp)>

<cfdump var="#matriz#">

<cfset ArrayDeleteAt(matriz, 5)>

<cfdump var="#matriz#">
--->

<!---
<cfinvoke component="sif.rh.Componentes.RH_ReporteCCSS_GC" method="ReporteCCSS" 
	returnvariable="err"
	Ecodigo= "177"
	periodo="2005" 
	mes="2" 
	GrupoPlanillas="OF"
	Usucodigo="27"
	conexion="impmonge"
	validar="false"
	debug="false">
</cfinvoke>

		<cfquery name="rh_ReporteCCSS_GC" datasource="impmonge">
				select * from Empresas
				select * from Articulos where Ecodigo=1
		</cfquery>
		
<cfstoredproc datasource="impmonge" procedure="rh_ReporteCCSS_GC">
	<cfprocresult name = RS1>
	<cfprocparam type = "IN" CFSQLType="CF_SQL_INTEGER"	value = "2005" dbVarName = @periodo>
	<cfprocparam type = "IN" CFSQLType="CF_SQL_INTEGER"	value = "2" dbVarName = @mes>
	<cfprocparam type = "IN" CFSQLType="CF_SQL_INTEGER"	value = "177" dbVarName = @Ecodigo>
	<!---<cfprocparam type = "IN" CFSQLType="CF_SQL_VARCHAR"	value = "OF   " dbVarName = @GrupoPlanillas>--->
</cfstoredproc>
<cfdump var="#rs1#">
--->

<!---
<cfinvoke component="sif.an.operacion.calculo.calculo" method="init" returnvariable="x">


<cfset x.calcularAnexo(2000000000000081,2003,1,1,-1,10) >
--->

<!--- SUMAR - RESTAR FECHAS JS
<html> 
<head> 
<script language="JavaScript"> 

  var aFinMes = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31); 

  function finMes(nMes, nAno){ 
   return aFinMes[nMes - 1] + (((nMes == 2) && (nAno % 4) == 0)? 1: 0); 
  } 

   function padNmb(nStr, nLen, sChr){ 
    var sRes = String(nStr); 
    for (var i = 0; i < nLen - String(nStr).length; i++) 
     sRes = sChr + sRes; 
    return sRes; 
   } 

   function makeDateFormat(nDay, nMonth, nYear){ 
    var sRes; 
    sRes = padNmb(nDay, 2, "0") + "/" + padNmb(nMonth, 2, "0") + "/" + padNmb(nYear, 4, "0"); 
    return sRes; 
   } 
    
  function incDate(sFec0){ 
   var nDia = parseInt(sFec0.substr(0, 2), 10); 
   var nMes = parseInt(sFec0.substr(3, 2), 10); 
   var nAno = parseInt(sFec0.substr(6, 4), 10); 
   nDia += 1; 
   if (nDia > finMes(nMes, nAno)){ 
    nDia = 1; 
    nMes += 1; 
    if (nMes == 13){ 
     nMes = 1; 
     nAno += 1; 
    } 
   } 
   return makeDateFormat(nDia, nMes, nAno); 
  } 

  function decDate(sFec0){ 
   var nDia = Number(sFec0.substr(0, 2)); 
   var nMes = Number(sFec0.substr(3, 2)); 
   var nAno = Number(sFec0.substr(6, 4)); 
   nDia -= 1; 
   if (nDia == 0){ 
    nMes -= 1; 
    if (nMes == 0){ 
     nMes = 12; 
     nAno -= 1; 
    } 
    nDia = finMes(nMes, nAno); 
   } 
   return makeDateFormat(nDia, nMes, nAno); 
  } 

  function addToDate(sFec0, sInc){ 
   var nInc = Math.abs(parseInt(sInc)); 
   var sRes = sFec0; 
   if (parseInt(sInc) >= 0) 
    for (var i = 0; i < nInc; i++) sRes = incDate(sRes); 
   else 
    for (var i = 0; i < nInc; i++) sRes = decDate(sRes); 
   return sRes; 
  } 

  function recalcF1(){ 
   with (document.formulario){ 
    fecha1.value = addToDate(fecha0.value, increm.value); 
   } 
  } 

</script> 
</head> 
<body> 
<form name="formulario"> 
  <table> 
   <tr> 
    <td align="right"> 
     Fecha (dd/mm/aaaa): 
    </td> 
    <td> 
     <input type="text" name="fecha0" size="10"> 
    </td> 
   </tr> 
   <tr> 
    <td align="right"> 
     Incremento: 
    </td> 
    <td> 
     <input type="text" name="increm" size="3"> 
    </td> 
   </tr> 
   <tr> 
    <td align="right"> 
     Resultado (dd/mm/aaaa): 
    </td> 
    <td> 
     <input type="text" name="fecha1" disabled size="10"> 
    </td> 
   </tr> 
   <tr> 
    <td colspan="2" align="center"> 
     <input type="button" onclick="recalcF1()" value="Calcular"> 
    </td> 
   </tr> 
  </table> 
</form> 
</body> 
</html> 
--->


<!--- Inserta en RHListaEvalDes --->
<!---
<cfquery datasource="#session.DSN#" name="data">
	select RHEEid, DEid
	from RHListaEvalDes
	where RHEEid=1240
	and promglobal is null
</cfquery>

<cfquery datasource="#session.DSN#" name="data">
	select RHNEDid
	from RHNotasEvalDes
	where RHEEid=1240
	and DEid=4839
</cfquery>

<cfoutput query="data">
	<cfset nota1 = RandRange(50,100)>
	<cfset nota2 = RandRange(50,100)>
	<cfset nota3 = RandRange(50,100)>
	<cfquery datasource="minisif">
		update RHNotasEvalDes
		set	RHNEDnotajefe=#nota1#,
			RHNEDnotaauto=#nota2#,
			RHNEDpromotros=#nota3#
		where RHEEid=1240 
		and RHNEDid=#data.RHNEDid#
	</cfquery>
	--->
<!---
	<cfquery datasource="minisif">
		update RHListaEvalDes
		set	RHLEnotajefe=#nota1#,
			RHLEnotaauto=#nota2#,
			RHLEpromotros=#nota3#
		where RHEEid=1240 
		and DEid=#data.DEid#
	</cfquery>
	--->

<!---
	<cfquery datasource="minisif">
		update RHListaEvalDes
		set	promglobal=(RHLEnotajefe+RHLEnotaauto+RHLEpromotros)/3
		where RHEEid=1240 
		and DEid=#data.DEid#
	</cfquery>
--->	

<!---
<cfset form.CFid = 1 >
<cfquery name="g" datasource="#session.DSN#" maxrows="100">
	select 	'#session.Enombre#' as empresa,
			rtrim(cf.CFcodigo)|| ' - ' || cf.CFdescripcion as CFcodigo,
			rtrim(c.RHCcodigo)||' - '|| c.RHCnombre as RHCcodigo, 
			c.RHCfdesde,
			c.RHCfhasta, 
			de.DEidentificacion, 
			de.DEnombre || ' ' ||de.DEapellido1 || ' ' ||de.DEapellido2 as DEnombre
	from RHEmpleadoCurso a
	
	inner join LineaTiempo lt
	on lt.Ecodigo=a.Ecodigo
	and lt.DEid=a.DEid
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">  between LTdesde and LThasta
	
	inner join DatosEmpleado de
	on de.DEid=a.DEid
	and de.Ecodigo=a.Ecodigo
	
	inner join RHPlazas p
	on p.Ecodigo=lt.Ecodigo
	and p.RHPid=lt.RHPid
	and p.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
	
	inner join CFuncional cf
	on cf.Ecodigo=p.Ecodigo
	and cf.CFid=p.CFid
	
	inner join RHCursos c
	on c.Ecodigo=a.Ecodigo
	and c.RHCid=a.RHCid
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	
	order by cf.CFcodigo, c.RHCcodigo, de.DEidentificacion
</cfquery>
--->

<!---<cfinclude template="../../demos/rh/insertaEmpleados.cfm">--->


<!---
<table width="80%" cellpadding="0" cellspacing="0"  align="center">
	<tr><td align="center"><strong>AVANZE</strong></td></tr>
	<tr>
		<td align="center">
		<table width="100%" style="border:1px solid black; " cellpadding="0" cellspacing="0" align="center">
			<tr><td align="center"><table align="left" id="avance" width="0%" bgcolor="#00CCFF"><tr><td id="progreso" align="center">&nbsp;</td></tr></table></td></tr>		</table>		</td>		<td width="1%" align="left">0%</td>
	</tr>
</table>
--->
<!---
<script type="text/javascript" language="javascript1.2">
	function y(avance){
		t = document.getElementById("avance");
		t.width = avance+'%';
	}

	function x(avance){
		setTimeout("location........",3000);
	}
	
	var w = 0;
	for( var i=0; i<=6 ;i++ ){
		w = w+16.6;
		x(w);
	}
</script>
--->

<!---
<html>
<head>
<script type="text/javascript">
	function insRow(){
		//var x=document.getElementById('myTable').insertRow(2)
		var x=document.getElementById('myTable');
		alert(x.rows)

/*
		var y=x.insertCell(0)
		var z=x.insertCell(1)
		y.innerHTML="NEW CELL1"
		z.innerHTML='<input type="button" value="Delete" onclick="deleteRow(this.parentNode.parentNode.rowIndex)">';
*/		
	}
	
	function deleteRow(i){
		document.getElementById('myTable').deleteRow(i)
	}
</script>
</head>

<body>
<table id="myTable" border="1">
<!---
<tr>
  <td>Row 1</td>
  <td><input type="button" value="Delete" onclick="deleteRow(this.parentNode.parentNode.rowIndex)"></td>
</tr>
<tr>
  <td>Row 2</td>
  <td><input type="button" value="Delete" onclick="deleteRow(this.parentNode.parentNode.rowIndex)"></td>
</tr>
<tr>
  <td>Row 3</td>
  <td><input type="button" value="Delete" onclick="deleteRow(this.parentNode.parentNode.rowIndex)"></td>
</tr>
--->
<input type="button" onclick="insRow()" value="Insert row">
</table>
</body>

</html>
--->


<cfinclude template="padron.cfm">

