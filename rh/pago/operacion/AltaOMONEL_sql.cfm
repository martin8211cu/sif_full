<!--- OPARRALES 2018-08-29
	- Layut de Alta OMONEL
 --->

<cfset myFechaFin = Trim(form.FechaFin) eq '' ? now() : form.FechaFin>
<cfquery name="rsCodCliente" datasource="#session.dsn#">
	select
		Pvalor
	from RHParametros
	where Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="14600703">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfif rsCodCliente.RecordCount eq 0 or (rsCodCliente.RecordCount gt 0 and Trim(rsCodCliente.Pvalor) eq '')>
	<cfthrow detail="El C&oacute;digo de Cliente para Despensas no se ha configurado." message="Par&aacute;metros RH: ">
</cfif>

<cfset varNumCliente = rsCodCliente.Pvalor>

<cfquery datasource="#session.dsn#" name="rsDatos">
	with R as (
		select
			'#varNumCliente#' as NumCliente,
			lt.DEid,
			de.DEidentificacion,
			coalesce(de.DEnombre,'') DEnombre,
			coalesce(de.DEapellido1,'') DEapellido1,
			coalesce(de.DEapellido2,'') DEapellido2,
			de.DEsexo,
			case de.DEcivil
				when 0 then 'S'
				when 1 then 'C'
			else '0' end as DEcivil,
			coalesce(de.CURP,'') CURP,
			coalesce(de.DESeguroSocial,'') DESeguroSocial,
			coalesce(de.RFC,'') RFC,
			coalesce(de.DEdato2,'') as NumTarjeta,
			lt.LThasta,
			lt.LTdesde,
			lt.LTid,
			o.Oficodigo,
			coalesce(o.Onumpatronal,'') Onumpatronal
			,row_number() over(partition by lt.DEid order by lt.LThasta DESC) as rn
		from RHTipoAccion ta
		inner join LineaTiempo lt
			on lt.RHTid = ta.RHTid
			and lt.Ecodigo = ta.Ecodigo
			and lt.BMusucodigo is not null
		inner join DatosEmpleado de
			on de.DEid = lt.DEid
			and lt.Ecodigo = de.Ecodigo
		inner join Oficinas o
			on o.Ocodigo = lt.Ocodigo
			and o.Ecodigo = lt.Ecodigo
		and de.DEdato1 is not null
		and de.DEdato1 = 1
		where RHTcomportam = 1 <!--- Nombramiento --->
		and lt.LTdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.FechaIni,'YYYY-MM-dd')#">
		and <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(myFechaFin,'YYYY-MM-dd')#">
		and ta.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	)
	select *
	from R
	where rn = 1;
</cfquery>
<cfoutput>
	<cfif rsDatos.RecordCount eq 0>
		<form name="form1" id="form1" action="AltaOMONEL_form.cfm"></form>
		<script type="text/javascript" language="javascript">
			alert('No hay datos para exportar');
			document.form1.submit();
		</script>

	</cfif>
</cfoutput>

<!--- DATOS OBLIGATORIOS POR EMPLEADO
	- Numero Cliente
	- Numero de Empleado
	- Nombre(s) Empleado
	- Primer apellido empleado
	- Segundo apellido empleado
	- Numero de tarjeta (DEdato2)
	- CURP
	- NSS
	- RFC
	- Numero patronal de la empresa ubicado en la oficina del empleado.
--->

<cfquery name="rsErrores" dbtype="query">
	select * from rsDatos
	where
	DEnombre = ''
	or DEapellido1 = ''
	or DEapellido2 = ''
	or NumTarjeta = ''
	or CURP = ''
	or DESEGUROSOCIAL = ''
	or RFC = ''
	or Onumpatronal = ''
</cfquery>

<cfset mensajeError = "">
<cfloop query="rsErrores">
	<cfset arrErrorTmp = ArrayNew(1)>
	<cfif mensajeError neq ''>
		<cfset ArrayAppend(arrErrorTmp,'<br />')>
	</cfif>

	<cfif Trim(DEnombre) eq ''>
		<cfset ArrayAppend(arrErrorTmp,'NombreEmpleado')>
	</cfif>

	<cfif Trim(DEapellido1) eq ''>
		<cfset ArrayAppend(arrErrorTmp,'ApellidoPaterno')>
	</cfif>

	<cfif Trim(DEapellido2) eq ''>
		<cfset ArrayAppend(arrErrorTmp,'ApellidoMaterno')>
	</cfif>

	<cfif Trim(NumTarjeta) eq ''>
		<cfset ArrayAppend(arrErrorTmp,'NumeroTarjetaDespensa')>
	</cfif>

	<cfif Trim(CURP) eq ''>
		<cfset ArrayAppend(arrErrorTmp,'CURP')>
	</cfif>

	<cfif Trim(RFC) eq ''>
		<cfset ArrayAppend(arrErrorTmp,'RFC')>
	</cfif>

	<cfif Trim(DESeguroSocial) eq ''>
		<cfset ArrayAppend(arrErrorTmp,'DESeguroSocial')>
	</cfif>

	<cfif Trim(Onumpatronal) eq ''>
		<cfset ArrayAppend(arrErrorTmp,'NumeroPatronal')>
	</cfif>

	<cfif !ArrayIsEmpty(arrErrorTmp)>
		<cfset mensajeError &= "Al Empleado #DEidentificacion# le falta configurar los siguientes datos: #ArrayToList(arrErrorTmp)#">
	</cfif>
</cfloop>

<cfif mensajeError neq ''>
	<cfthrow message="Validacion Empleado: " detail="#mensajeError#">
</cfif>

<cfset NL = Chr(13)&Chr(10)>
<cfset TextoFile = "">
<cfloop query="rsDatos">

	<cfset varDEnombre = generateSlug(DEnombre)>
	<cfset varDEapellido1 = generateSlug(DEapellido1)>
	<cfset varDEapellido2 = generateSlug(DEapellido2)>
	<cfset varCURP = generateSlug(CURP)>
	<cfset varOnumpatronal = generateSlug(Onumpatronal)>
	<cfset varNumTarjeta = generateslug(NumTarjeta)>
	<cfset varDESeguroSocial = generateslug(DESeguroSocial)>

	<cfset unaLinea = "">
	<cfset unaLinea &= RepeatString("0",7-Len(Trim(NumCliente))) & Trim(NumCliente)>
	<cfset unaLinea &= RepeatString("0",4)>
	<cfset unaLinea &= RepeatString("0",7)>
	<cfset unaLinea &= RepeatString("0",10-Len(Trim(DEidentificacion))) & Trim(DEidentificacion)>
	<cfset unaLinea &= Trim(varDEnombre) 	 & RepeatString(" ",30-Len(Trim(varDEnombre)))>
	<cfset unaLinea &= Trim(varDEapellido1) & RepeatString(" ",30-Len(Trim(varDEapellido1)))>
	<cfset unaLinea &= Trim(varDEapellido2) & RepeatString(" ",30-Len(Trim(varDEapellido2)))>
	<!--- <cfset unaLinea &= "00"> --->
	<cfset unaLinea &= RepeatString("0",10)>
	<cfset unaLinea &= RepeatString("0",10)>
	<cfset unaLinea &= "00">
	<cfset unaLinea &= "00">
	<cfset unaLinea &= "#Trim(DEsexo)#">
	<cfset unaLinea &= "0">
	<cfset unaLinea &= RepeatString("0",25)>
	<cfset unaLinea &= RepeatString(" ",16-Len(Trim(varNumTarjeta))) & Trim(varNumTarjeta)>
	<cfset unaLinea &= Trim(varCURP)>
	<cfset unaLinea &= Trim(varDESeguroSocial)>
	<cfset unaLinea &= RepeatString(" ",13-Len(Trim(RFC))) & Trim(RFC)>
	<cfset unaLinea &= RepeatString(" ",11-Len(Trim(varOnumpatronal))) & Trim(varOnumpatronal)>

	<cfif TextoFile neq "">
		<cfset TextoFile &= "#NL#">
	</cfif>
	<cfset TextoFile &= "#unaLinea#">
</cfloop>

<cfset fileName = "AltasOMONEL-"&"#LSDateFormat(form.FechaIni,'YYYY-MM-dd')#TO"&"#LSDateFormat(myFechaFin,'YYYY-MM-dd')#"&".txt">
<cfset filePath = "ram:///#fileName#">
<cffile action="write" file="#filePath#" charset="utf-8" output="#TextoFile#" addnewline="false">
<cfheader name="Content-Disposition" value="attachment; filename=#fileName#">
<cfcontent type="text/plain" file="#filePath#" deletefile="yes">

<cflocation url="AltaOMONEL_form.cfm">

<cffunction name="generateSlug" output="false" returnType="string">
    <cfargument name="str" default="">
    <cfargument name="spacer" default="-">
    <cfset var ret = replace(arguments.str,"'", "", "all")>
    <cfset ret = replace(arguments.str,"/", "", "all")>
    <cfset ret = trim(ReReplaceNoCase(ret, "<[^>]*>", "", "ALL"))>
    <cfset ret = ReplaceList(ret, "À,Á,Â,Ã,Ä,Å,Æ,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,Ø,Ù,Ú,Û,Ü,Ý,à,á,â,ã,ä,å,æ,è,é,ê,ë,ì,í,î,ï,Ñ,ñ,ò,ó,ô,õ,ö,ø,ù,ú,û,ü,ý,&nbsp;,&amp;", "A,A,A,A,A,A,AE,E,E,E,E,I,I,I,I,D,N,O,O,O,O,O,0,U,U,U,U,Y,a,a,a,a,a,a,ae,e,e,e,e,i,i,i,i,N,n,o,o,o,o,o,0,u,u,u,u,y, , ")>
    <!--- <cfset ret = trim(rereplace(ret, "[[:punct:]]"," ","all"))> --->
    <!--- <cfset ret = rereplace(ret, "[[:space:]]+","!","all")> --->
    <cfset ret = ReReplace(ret, "[^a-zA-Z0-9!]", " ", "ALL")>
    <!--- <cfset ret = trim(rereplace(ret, "!+", arguments.Spacer, "all"))> --->
    <cfreturn ret>
</cffunction>
