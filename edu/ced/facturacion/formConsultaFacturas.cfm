<cfset filtro = "">
<cfset navegacion = ""> 
<cfif isdefined("Form.fEFnombredoc") AND #Form.fEFnombredoc# NEQ "" >
	<cfset filtro = #filtro# &" and upper(a.EFnombredoc) like upper('%" & #Form.fEFnombredoc# & "%')">	
	<cfset f1 = Form.fEFnombredoc>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fEFnombredoc=" & Form.fEFnombredoc>
</cfif>	
<cfif isdefined("Form.fEFnumdoc") AND len(trim(#Form.fEFnumdoc#)) NEQ 0 >
	<cfset filtro = #filtro# &" and rtrim(ltrim(a.EFnumdoc))= '" & trim(#Form.fEFnumdoc#) & "'" >	
	<cfset f2 = Form.fEFnumdoc>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fEFnumdoc=" & trim(Form.fEFnumdoc)>
</cfif>				
<cfif isdefined("Form.fEFfechadoc") AND #Form.fEFfechadoc# NEQ "">
	<cfset filtro = #filtro# & " and convert(datetime,a.EFfechadoc,103) between convert(datetime, '" & #form.fEFfechadoc# & "', 103)" & " and convert(datetime, '"& #form.fEFfechadoc# & "', 103)">
	<cfset f3 = Form.fEFfechadoc>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fEFfechadoc=" & Form.fEFfechadoc>
</cfif>
<cfif isdefined("Form.fEFfechavenc") AND #Form.fEFfechavenc# NEQ "">
	<cfset filtro = #filtro# & " and convert(datetime,a.EFfechavenc,103) between convert(datetime, '" & #form.fEFfechavenc# & "', 103)" & " and convert(datetime, '"& #form.fEFfechavenc# & "', 103)">
	<cfset f4 = Form.fEFfechavenc>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fEFfechavenc=" & Form.fEFfechavenc>
</cfif>
<cfinvoke 
 component="edu.Componentes.pListas"
 method="pListaEdu"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="tabla" value="EFactura a"/>
	<cfinvokeargument name="columnas" value="convert(varchar, a.EFid) as EFid, a.EFconsecutivo, a.EFnumdoc, a.EFnombredoc, a.CEcontrato,
											 convert(varchar, a.EFfechadoc, 103) as EFfechadoc, 
											 convert(varchar, a.EFfechavenc, 103) as EFfechavenc, 
											 a.EFfechapago, a.EFfechasis, a.EFporcdesc, a.EFmontodesc, 
											 convert(varchar, a.EFtotal, 1) as EFtotal, a.EFestado, a.EFobservacion"/>
	<cfinvokeargument name="desplegar" value="EFnumdoc, EFnombredoc, EFfechadoc, EFfechavenc, EFtotal"/>
	<cfinvokeargument name="etiquetas" value="No. Documento, Nombre, Fecha del Documento, Fecha Vencimiento, Importe"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="filtro" value="a.CEcodigo = #Session.Edu.CEcodigo# #filtro#
	                                   and a.EFestado = 'T'"/>
	<cfinvokeargument name="align" value="left, left, center, center, right"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="irA" value="ConsultaFacturas.cfm"/>
	<cfinvokeargument name="maxrows" value="17"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>
