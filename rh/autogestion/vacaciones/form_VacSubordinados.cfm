<cfif isdefined("url.month") and len(trim(url.month)) gt 0 and not isdefined("form.month")  >
	<cfset form.month = url.month>
</cfif>
<cfif isdefined("url.year") and len(trim(url.year)) gt 0 and not isdefined("form.year")  >
	<cfset form.year = url.year>
</cfif>


<!--- size form --->
<cfif isdefined("form.imprimir") and form.imprimir eq 'N'>
	<!--- 
		<cfparam name="form.width" default="420">
		<cfparam name="form.height" default="420">
		<cfparam name="form.cellheight" default="90">
		<cfparam name="form.cellwidth" default="130"> 
	--->
	<cfparam name="form.width" default="420">
	<cfparam name="form.height" default="420">
	<cfparam name="form.cellheight" default="90">
	<cfparam name="form.cellwidth" default="130"> 
<cfelse>
	<cfparam name="form.width" default="350">
	<cfparam name="form.height" default="350">
	<cfparam name="form.cellheight" default="85">
	<cfparam name="form.cellwidth" default="120">
	<cf_templatecss>
</cfif>

<cf_dbtemp name="VACACIONES_TEMPv1" returnvariable="VACACIONES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="DIA"   type="integer" mandatory="yes">
	<cf_dbtempcol name="MES"   type="integer" mandatory="yes">
	<cf_dbtempcol name="FECHA" type="date" mandatory="yes">
	<cf_dbtempcol name="VACACION" type="varchar(2048)" mandatory="no">
</cf_dbtemp>

<cfset firstOfTheMonth = createDate(form.year, form.month, 1)>
<cfset daysInLastMonth = daysInMonth(firstOfTheMonth)>

<cfloop index="Z" from="1" to="#daysInLastMonth#">

	<cfset fecha = createDate(form.year, form.month, Z)>
	<cf_dbfunction name="to_char" args="a.DLlinea" returnvariable="vDLlinea">
	<cf_dbfunction name="to_char" args="a.DEid" returnvariable="vDEid">
	
	<cfquery name="rsvacaciones" datasource="#Session.DSN#">
		select 	
		{fn concat(#vDEid#,{fn concat('|',{fn concat(de.DEnombre,{fn concat(' ',{fn concat(de.DEapellido1,{fn concat(' ',de.DEapellido2)})})})})})}
		as persona
		from DLaboralesEmpleado a 
		inner join RHTipoAccion b
			on 	a.RHTid = b.RHTid
			and b.RHTcomportam = 3
		inner join DatosEmpleado de
			on a.DEid = de.DEid
			and a.Ecodigo = de.Ecodigo	
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.DEid  in (#PreserveSingleQuotes(subordinados)#)
		and <cfqueryparam value="#fecha#" cfsqltype="cf_sql_timestamp">  between  a.DLfvigencia and a.DLffin
		order by   
		de.DEnombre ,de.DEapellido1,de.DEapellido2
	</cfquery>
	<cfif isdefined("rsvacaciones") and rsvacaciones.recordCount GT 0>
		<cfset vacaciones = ValueList(rsvacaciones.persona,",")>
		<cfquery name="rsinsert" datasource="#Session.DSN#">
			insert into  #VACACIONES_TEMP#(DIA,MES,FECHA,VACACION)
			values (#Z#,#form.month#,#fecha#,'#vacaciones#')
		</cfquery>
	<cfelse>
		
		<cfquery name="rsinsert" datasource="#Session.DSN#">
			insert into  #VACACIONES_TEMP#(DIA,MES,FECHA)
			values (#Z#,#form.month#,#fecha#)
		</cfquery>
	</cfif>
</cfloop>

<cfoutput>



<style>

.cal {
	height: #form.height#;
	width: #form.width#;
}

.calheader {
	background-color: ##c0c0c0;
}

.calheader_text {
	font-weight: bold;
	font-family: arial;
	font-size:13px;
	width: #form.cellwidth#;
	
}

.cell {
	height: #form.cellheight#;
	width: #form.cellwidth#;
	border-top-width: 1px;
	border-top-color: black;
	border-top-style: solid;
	border-right-width: 1px;
	border-right-color: black;
	border-right-style: solid;
	border-bottom-width: 1px;
	border-bottom-color: black;
	border-bottom-style: solid;
	border-left-width: 1px;
	border-left-color: black;
	border-left-style: solid;
}	

.cell_today {
	height: #form.cellheight#;
	width: #form.cellwidth#;
	background-color: lightyellow;
	border-top-width: 1px;
	border-top-color: black;
	border-top-style: solid;
	border-right-width: 1px;
	border-right-color: black;
	border-right-style: solid;
	border-bottom-width: 1px;
	border-bottom-color: black;
	border-bottom-style: solid;
	border-left-width: 1px;
	border-left-color: black;
	border-left-style: solid;
}	

.cell_X {
	width: #form.cellwidth#;
}	
.offMonthCell {
	background-color: lightgrey  ;
	border-top-width: 1px;
	border-top-color: black;
	border-top-style: solid;
	border-right-width: 1px;
	border-right-color: black;
	border-right-style: solid;
	border-bottom-width: 1px;
	border-bottom-color: black;
	border-bottom-style: solid;
	border-left-width: 1px;
	border-left-color: black;
	border-left-style: solid;}
	
</style>
<!--- Meses--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Enero"
	Default="Enero"
	returnvariable="Enero"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Febrero"
	Default="Febrero"
	returnvariable="Febrero"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Marzo"
	Default="Marzo"
	returnvariable="Marzo"/>		
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Abril"
	Default="Abril"
	returnvariable="Abril"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Mayo"
	Default="Mayo"
	returnvariable="Mayo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Junio"
	Default="Junio"
	returnvariable="Junio"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Julio"
	Default="Julio"
	returnvariable="Julio"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Agosto"
	Default="Agosto"
	returnvariable="Agosto"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Septiembre"
	Default="Septiembre"
	returnvariable="Septiembre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Octubre"
	Default="Octubre"
	returnvariable="Octubre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Noviembre"
	Default="Noviembre"
	returnvariable="Noviembre"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Diciembre"
	Default="Diciembre"
	returnvariable="Diciembre"/>								
<!--- Dias de la semana --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Lunes"
	Default="Lunes"
	returnvariable="Lunes"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Lunes"
	Default="Lunes"
	returnvariable="Lunes"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Martes"
	Default="Martes"
	returnvariable="Martes"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Miercoles"
	Default="Mi&eacute;rcoles"
	returnvariable="Miercoles"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Jueves"
	Default="Jueves"
	returnvariable="Jueves"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Viernes"
	Default="Viernes"
	returnvariable="Viernes"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Sabado"
	Default="S&aacute;bado"
	returnvariable="Sabado"/> 
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Domingo"
	Default="Domingo"
	returnvariable="Domingo"/> 


<cfif isdefined("form.imprimir") and form.imprimir eq 'N'>
	<cfoutput>
	<cfif isdefined("form.limitar")>
		<cf_rhimprime datos="/rh/autogestion/vacaciones/VacSubordinados.cfm" paramsuri="&imprimir=s&year=#form.year#&month=#form.month#" >
	<cfelse>
		<cf_rhimprime datos="/rh/autogestion/vacaciones/VacSubordinados.cfm" paramsuri="&imprimir=s&year=#form.year#&limitar=1&month=#form.month#" >
	</cfif>
	</cfoutput>

</cfif>

<form style="margin:0" name="form1" method="post">
 	<table   border="0"width="100%" cellpadding="0" cellspacing="0">
		<cfif isdefined("form.imprimir") and form.imprimir eq 'N'>
		<tr>
			<td colspan="3">
				<strong><input  onclick="javascript:document.form1.submit();" type="checkbox" <cfif isdefined("form.limitar")>checked</cfif> name="limitar" tabindex="1" value="1"><cf_translate key="CHK_Limitar_consulta_a_un_nivel">Limitar consulta a un nivel.</cf_translate></strong>
			</td>
		</tr>
		</cfif>
		<cfif isdefined("form.imprimir") and form.imprimir eq 'N'>
		<tr>
			<td align="right"><img   tabindex="1" onclick="javascript: atras();" border="0" src="/cfmx/rh/imagenes/rev.gif" style="cursor:pointer"/></td>
			<td  width="15%"align="center" nowrap="nowrap">
				
				<select  tabindex="1" name="month" style="font-size:15px;font-weight:bold" id="year" onchange="javascript:document.form1.submit();" tabindex="1">
					<option value="1"  <cfif isdefined("form.month") and form.month EQ 1>  selected</cfif>><b>#ucase(Enero)#</b></option>
					<option value="2"  <cfif isdefined("form.month") and form.month EQ 2>  selected</cfif>><b>#ucase(Febrero)#</b></option>
					<option value="3"  <cfif isdefined("form.month") and form.month EQ 3>  selected</cfif>><b>#ucase(Marzo)#</b></option>
					<option value="4"  <cfif isdefined("form.month") and form.month EQ 4>  selected</cfif>><b>#ucase(Abril)#</b></option>
					<option value="5"  <cfif isdefined("form.month") and form.month EQ 5>  selected</cfif>><b>#ucase(Mayo)#</b></option>
					<option value="6"  <cfif isdefined("form.month") and form.month EQ 6>  selected</cfif>><b>#ucase(Junio)#</b></option>
					<option value="7"  <cfif isdefined("form.month") and form.month EQ 7>  selected</cfif>><b>#ucase(Julio)#</b></option>
					<option value="8"  <cfif isdefined("form.month") and form.month EQ 8>  selected</cfif>><b>#ucase(Agosto)#</b></option>
					<option value="9"  <cfif isdefined("form.month") and form.month EQ 9>  selected</cfif>><b>#ucase(Septiembre)#</b></option>
					<option value="10" <cfif isdefined("form.month") and form.month EQ 10> selected</cfif>><b>#ucase(Octubre)#</b></option>
					<option value="11" <cfif isdefined("form.month") and form.month EQ 11> selected</cfif>><b>#ucase(Noviembre)#</b></option>
					<option value="12" <cfif isdefined("form.month") and form.month EQ 12> selected</cfif>><b>#ucase(Diciembre)#</b></option>
				</select>
				<select name="year" id="year" style="font-size:15px; font-weight:bold" tabindex="1" onchange="javascript:document.form1.submit();">
					<cfloop from="#year(now())-5#" to="#year(now())+5#" index="i">
						<option value="#i#" <cfif  isdefined("form.year") and form.year EQ i >selected</cfif>><b>#i#</b></option>
					</cfloop>
				</select>	
				
				
			</td>
			<td align="left"><img   tabindex="1" onclick="javascript: siguiente();" border="0" src="/cfmx/rh/imagenes/play.gif"  style="cursor:pointer"></td>
		</tr>
			<cfelse>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MENU_Consulta_de_vacaciones_de_colaboradores"
					Default="Consulta de vacaciones de colaboradores "
					returnvariable="MENU_Vacaciones_colaboradores"/>
			
	
			
			<tr>
				<td colspan="2" align="left" bgcolor="##CCCCCC"><b>
					<font  style="font-size:20px">
					<cfswitch expression="#form.month#">
						<cfcase value="1">
							#ucase(Enero)#
						</cfcase>
						<cfcase value="2">
							#ucase(Febrero)#
						</cfcase>
						<cfcase value="3">
							#ucase(Marzo)#
						</cfcase>
						<cfcase value="4">
							#ucase(Abril)#
						</cfcase>
						<cfcase value="5">
							#ucase(Mayo)#
						</cfcase>
						<cfcase value="6">
							#ucase(Junio)#
						</cfcase>
						<cfcase value="7">
							#ucase(Julio)#
						</cfcase>
						<cfcase value="8">
							#ucase(Agosto)#
						</cfcase>
						<cfcase value="9">
							#ucase(Septiembre)#
						</cfcase>
						<cfcase value="10">
							#ucase(Octubre)#
						</cfcase>
						<cfcase value="11">
							#ucase(Noviembre)#
						</cfcase>
						<cfcase value="12">
							#ucase(Diciembre)#
						</cfcase>						
					</cfswitch>
					&nbsp;&nbsp;&nbsp;
					#form.year#</b>
					</font>
				</td>
				
				<tr>
				<td colspan="2" align="center" bgcolor="##CCCCCC"><b>
					#MENU_Vacaciones_colaboradores#
				</b></td>
				</tr>
				<tr>
				<td colspan="2" align="center" bgcolor="##CCCCCC"><b>
					<cfquery name="RSCF" datasource="#Session.DSN#">
						select 
						{fn concat(CFcodigo,{fn concat(' ',CFdescripcion)})} as  CFcodigo
						from  CFuncional
						where CFid   =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#esjefe.CFid#">
						and Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
					#RSCF.CFcodigo#
				</b></td>
				</tr>				
				<tr>
					<td colspan="2" >&nbsp;</td>
				</tr>
		</cfif>
	</table>
</form> 


<table border="0"  width="100%" cellpadding="0" cellspacing="0">
	<tr class="calheader">
	<cfloop index="x" from="1" to="7">
		<cfset dia = "">
		<cfswitch expression="#x#">
			<cfcase value="2">
				<cfset dia= #Lunes#>
			</cfcase>
			<cfcase value="3">
				<cfset dia= #Martes#>
			</cfcase>
			<cfcase value="4">
				<cfset dia= #Miercoles#>
			</cfcase>
			<cfcase value="5">
				<cfset dia= #Jueves#>
			</cfcase>
			<cfcase value="6">
				<cfset dia= #Viernes#>
			</cfcase>
			<cfcase value="7">
				<cfset dia= #Sabado#>
			</cfcase>
			<cfcase value="1">
				<cfset dia=#Domingo#>
			</cfcase>		
		</cfswitch>
		<th class="calheader_text">
			#dia#
		</th>
	</cfloop>
	</tr>
</cfoutput>

<cfset firstOfTheMonth = createDate(form.year, form.month, 1)>
<cfset dow = dayofWeek(firstOfTheMonth)>
<cfset pad = dow - 1>

<cfoutput>
<tr valign="top">
</cfoutput>

<cfquery name="RSdias" datasource="#Session.DSN#">
	 SELECT * FROM #VACACIONES_TEMP# 
	 order by DIA
</cfquery>

<cfif pad gt 0>
	<!--- get previous month --->
	<cfset lastMonth = dateAdd("m", -1, firstOfTheMonth)>
	<cfset daysInLastMonth = daysInMonth(lastMonth)>
	<cfloop index="x" from="#daysInLastMonth-pad+1#" to="#daysInLastMonth#">
		<cfoutput><td  class="offMonthCell"> #x#</td></cfoutput>
	</cfloop>
</cfif>

<cfset days = daysInMonth(firstOfTheMonth)>
<cfset counter = pad + 1>
<cfif RSdias.recordCount GT 0>
	<cfloop query="RSdias">
		<cfquery name="RSFeriado" datasource="#Session.DSN#">
			 SELECT * FROM RHFeriados
			where  <cf_dbfunction name="to_datechar" args="RHFfecha"> = <cfqueryparam cfsqltype="cf_sql_date" value="#RSdias.FECHA#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
		</cfquery>
		<cfif RSdias.DIA is day(form.today) and form.month is month(form.today) and form.year is year(form.today)>
			<cfoutput><td class="cell_today"></cfoutput>
		<cfelseif RSFeriado.recordCount GT 0>
			<cfoutput><td class="offMonthCell"></cfoutput>
		<cfelse>
			<cfoutput><td class="cell"></cfoutput>
		</cfif>
	    <table border="0"  width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td><cfoutput>#RSdias.DIA# <cfif RSFeriado.recordCount GT 0><font  style="font-size:9px">#RSFeriado.RHFdescripcion#</font></cfif></cfoutput></td>
			</tr>
			<tr>
			<td>	
			<cfif isdefined("form.imprimir") and form.imprimir eq 'N'>
				<div align="center" style=" width:145px; height:100px;  overflow:auto; display:block; padding: 10 10 10 10;"> 
			</cfif>
			<table border="0"  width="100%" cellpadding="0" cellspacing="0">	
			<cfif isdefined("RSdias.VACACION") and len(trim(RSdias.VACACION))>
				<cfset arreglo = listtoarray(RSdias.VACACION,",")>							
				<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
					<cfset arreglo2 = listtoarray(arreglo[i],"|")>
					
					<tr>
						<td nowrap="nowrap" class="botonUp" 
							onmouseover="javascript: buttonOver(this);" 
							onmouseout="javascript: buttonOut(this);" 
							<cfif isdefined("arreglo2") and arraylen(arreglo2) eq 2>
								onClick="javascript: return VerVacaciones(<cfoutput>#arreglo2[1]#,#DateFormat(RSdias.FECHA,'yyyymmdd')#</cfoutput>);"
							</cfif>
							>
							
						<font  style="font-size:8.5px"><cfoutput><cfif isdefined("arreglo2") and arraylen(arreglo2) eq 2> #ucase(arreglo2[2])#</cfif></cfoutput></font>
						</td>
					</tr>
					
				</cfloop>
			<cfelse>
				<tr>
					<td nowrap="nowrap">
					 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</td>
				</tr>
			</cfif>
			</table>
			<cfif isdefined("form.imprimir") and form.imprimir eq 'N'>
				</div>
			</cfif>
			<td>
			</tr>
		</table>
		<cfoutput></td></cfoutput>
		
		<cfset counter = counter + 1>
		
		<cfif counter is 8>
			<cfoutput></tr></cfoutput>
			<cfif RSdias.DIA lt days>
				<cfset counter = 1>
				<cfoutput><tr valign="top"></cfoutput>
			</cfif>
		</cfif>
	</cfloop>
<cfelse>
	<cfloop index="x" from="1" to="#days#">
		<cfif x is day(form.today) and form.month is month(form.today) and form.year is year(form.today)>
			<cfoutput><td class="cell_today"></cfoutput>
		<cfelse>
			<cfoutput><td class="cell"></cfoutput>
		</cfif>
	   
		<cfoutput>#x#</cfoutput>
	
		<cfoutput></td></cfoutput>
		
		<cfset counter = counter + 1>
		
		<cfif counter is 8>
			<cfoutput></tr></cfoutput>
			<cfif x lt days>
				<cfset counter = 1>
				<cfoutput><tr valign="top"></cfoutput>
			</cfif>
		</cfif>
	</cfloop>
</cfif>



<cfif counter is not 8>
	<cfset endPad = 8 - counter>
	<cfloop index="x" from="1" to="#endPad#">
		<cfoutput>
		<td class="offMonthCell">#x#</td>
		</cfoutput>
	</cfloop>
</cfif>

<cfoutput>
</table>

</cfoutput>

<script language="javascript" type="text/javascript">
	function buttonOver(obj) {
		obj.className="botonDown";
	}

	function buttonOut(obj) {
		obj.className="botonUp";
	}
	
	function VerVacaciones(valor,valor2) {
		var PARAM  = "ListaVacaciones.cfm?DEid="+ valor + "&Fecha=" + valor2
		open(PARAM,'Vacaciones','left=150,top=150,scrollbars=yes,resizable=yes,width=900,height=450')
	}
	
	function atras() {
		var month =  new Number(document.form1.month.value);
		var year =  new Number(document.form1.year.value);
		if (month == 1){
			month = 12;
			year  = year-1;
		}
		else{
			month = month -1;
		}
		document.form1.month.value= month;
		document.form1.year.value=year;
		document.form1.submit();
	}

	function siguiente() {
		var month =  new Number(document.form1.month.value);
		var year =  new Number(document.form1.year.value);
		if (month == 12){
			month = 1;
			year  = year+1;
		}
		else{
			month = month +1;
		}
		document.form1.month.value= month;
		document.form1.year.value=year;
		document.form1.submit();
	}

</script>





	
	
