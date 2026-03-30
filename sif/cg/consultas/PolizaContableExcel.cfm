<cfsetting enablecfoutputonly="no">

<cfinclude template="Funciones.cfm">		
<cfset periodo="#get_val(30).Pvalor#">	   	
<cfset mes="#get_val(40).Pvalor#">

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Poliza = t.Translate('LB_Poliza','P&oacute;liza')>
<cfset LB_Descripcion = t.Translate('LB_Descripcion','Descripción')>
<cfset LB_Referencia = t.Translate('LB_Referencia','Ref')>
<cfset LB_Lote= t.Translate('LB_Lote','Lote')> 
<cfset LB_Documento=t.Translate('LB_Documento','Doc. Base')>
<cfset LB_Periodo=t.Translate('LB_Periodo','Periodo')>
<cfset LB_Fecha=t.Translate('LB_Fecha','Fecha')>
<cfset LB_AsientoAplicado=t.Translate('LB_AsientoAplicado','Aplic&oacute; Asiento')>
<cfset LB_Monto=t.Translate('LB_Monto','Monto')>
<cfset LB_Titulo=t.Translate('LB_Titulo','Consulta de Pólizas Contabilizadas')>
<cfset LB_Archivo=t.Translate('LB_Archivo','PolizaContabilizada')>
<cfset LB_Mes=t.Translate('LB_Mes','Mes')>
<cfset LB_Asiento=t.Translate('LB_Asiento','Asiento')>
<cfset LB_Aplicacion=t.Translate('LB_Aplicacion','Aplicacion')>
<cfset LB_Lineas=t.Translate('LB_Lineas','Lineas')>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsLista" datasource="#Session.DSN#">
	select distinct
		a.IDcontable, 
		a.Edocumento, 
		a.Edescripcion as Edescripcion,
		<cf_dbfunction name="to_char" args="a.Eperiodo"> #_Cat# ' / ' #_Cat#  <cf_dbfunction name="to_char" args="a.Emes"> as fecha,  
		a.Efecha, 
		coalesce((
			select sum(Dlocal)
			from 
			<cfif isdefined("Form.intercomp")>				
					HDContablesInt d
			<cfelse>
					HDContables d
			</cfif>
			where d.IDcontable = a.IDcontable
			  and d.Dmovimiento = 'D'
		), 0.00) as Monto,
		((
			select count(1)
			from HDContables d
			where d.IDcontable = a.IDcontable
		)) as Lineas,
		a.ECfechaaplica as fechaAplica,
		a.Cconcepto as Cconcepto,
        a.Edocbase,
        a.Ereferencia,
        a.Eperiodo, 
        a.Emes
	from HEContables a
		<cfif isdefined("Form.intercomp")>
			INNER JOIN EControlDocInt ei on ei.idcontableori=a.IDcontable
			INNER JOIN HDContablesInt hdi on hdi.IDcontable=a.IDcontable
			and ei.idcontableori=hdi.IDcontable			 
		</cfif>
	    <cfif isdefined("url.LvarAsientoRecursivo") and len(trim(url.LvarAsientoRecursivo))>
        	inner join AsientosRecursivos b
            	on b.IDcontable = a.IDcontable
                and b.Ecodigo = a.Ecodigo
        </cfif>
		<cfif isdefined("Form.anulados")>
			inner join HDContables hd on hd.IDcontable=a.IDcontable
		</cfif>
	where a.Ecodigo = #Session.Ecodigo#
	<cfif isdefined("Form.CHKMesCierre")>
		and a.ECtipo = 1
	<cfelse>
		and a.ECtipo <> 1
	</cfif>
	<cfif isdefined("Form.Cconcepto") and (Len(Trim(Form.Cconcepto)) NEQ 0) and (Form.Cconcepto NEQ "-1")>
		and a.Cconcepto = #Form.Cconcepto#
	</cfif>
	<cfif isdefined("Form.Eperiodo") and (Len(Trim(Form.Eperiodo)) NEQ 0) and (Form.Eperiodo NEQ "-1")>
		and a.Eperiodo = #Form.Eperiodo#
	<cfelseif not isdefined("Form.Eperiodo")>
		and a.Eperiodo = #periodo#
	</cfif>
	<cfif isdefined("Form.Emes") and (Len(Trim(Form.Emes)) NEQ 0) and (Form.Emes NEQ "-1")>
		and a.Emes = #Form.Emes#
	<cfelseif not isdefined("Form.Emes")>
		and a.Emes = #mes#
	</cfif>
	<cfif isdefined("Form.Edocumento") and (Len(Trim(Form.Edocumento)) NEQ 0)>
		and a.Edocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Edocumento#">
	</cfif>
	<cfif isdefined("Form.Edescripcion") and (Len(Trim(Form.Edescripcion)) NEQ 0)>
		and upper(a.Edescripcion) like '%#Ucase(Form.Edescripcion)#%'
	</cfif>
	<cfif isdefined("Form.fecha") and (Len(Trim(Form.fecha)) NEQ 0)>			
		and a.Efecha >= #LSParseDateTime(Form.fecha)#
	</cfif>
	<cfif isdefined("Form.ECusuario") and form.ECusuario NEQ 'Todos'>
		and a.ECusuario = '#form.ECusuario#'
	</cfif>
   	<cfif isdefined("Form.fechaaplica") and (Len(Trim(Form.fechaaplica)) NEQ 0)>			
		and a.ECfechaaplica >= #LSParseDateTime(Form.fechaaplica)#
		and a.ECfechaaplica <= #dateadd('d', 1, LSParseDateTime(Form.fechaaplica))#
	</cfif>
    <cfif isdefined("Form.txtref")>
    	and a.Ereferencia like '%#form.txtref#%'
    </cfif>
    <cfif isdefined("Form.txtdoc")>
    	and a.Edocbase like '%#form.txtdoc#%'
    </cfif>
	<cfif isdefined("Form.intercomp")>
    	and a.ECtipo = 20
    </cfif>

	order by a.Eperiodo desc, a.Emes desc, a.Cconcepto, a.Edocumento			
</cfquery>

<cfset titulos = "">
<cfif isdefined("Form.CHKMesCierre")>
	<cfset titulos = titulos & " " & "Asientos de Cierre">
</cfif>
<cfif isdefined("Form.Cconcepto") and (Len(Trim(Form.Cconcepto)) NEQ 0) and (Form.Cconcepto NEQ "-1")>
	<cfset titulos = titulos & " " & "#LB_Lote#: #form.Cconcepto#">
</cfif>
<cfif isdefined("Form.Eperiodo") and (Len(Trim(Form.Eperiodo)) NEQ 0) and (Form.Eperiodo NEQ "-1")>
	<cfset titulos = titulos & " " & "#LB_Periodo#: #form.Eperiodo#">
<cfelseif not isdefined("Form.Eperiodo")>
	<cfset titulos = titulos & " " & "#LB_Periodo#: #periodo#">
</cfif>
<cfif isdefined("Form.Emes") and (Len(Trim(Form.Emes)) NEQ 0) and (Form.Emes NEQ "-1")>
	<cfset titulos = titulos & " " & "#LB_Mes#: #form.Emes#">
<cfelseif not isdefined("Form.Emes")>
	<cfset titulos = titulos & " " & "#LB_Mes#: #Mes#">
</cfif>
<cfif isdefined("Form.Edocumento") and (Len(Trim(Form.Edocumento)) NEQ 0)>
	<cfset titulos = titulos & " " & "#LB_Documento#: #form.Edocumento#">
</cfif>
<cfif isdefined("Form.Edescripcion") and (Len(Trim(Form.Edescripcion)) NEQ 0)>
	<cfset titulos = titulos & " " & "#LB_Descripcion#: #form.Edescripcion#">
</cfif>
<cfif isdefined("Form.fecha") and (Len(Trim(Form.fecha)) NEQ 0)>			
	<cfset titulos = titulos & " " & "#LB_Fecha#: #lsDateformat(form.Emes, "DD/MM/YYYY")#">
</cfif>
<cfif isdefined("Form.ECusuario") and form.ECusuario NEQ 'Todos'>
	<cfset titulos = titulos & " " & "#LB_Usuario#: #form.ECusuario#">
</cfif>

<cfsetting enablecfoutputonly="no">

<cfset LvarReturn = 'PolizaContable.cfm'>
<cfif isdefined("url.LvarAsientoRecursivo") and len(trim(url.LvarAsientoRecursivo))>
	<cfset LvarReturn = 'AsientosRecursivos.cfm'>
</cfif>
<cf_templatecss>
<cf_htmlreportsheaders irA="#LvarReturn#" FileName="#LB_Archivo#.xls">
<form name="formdet" action="PolizaContable.cfm" method="get">
<table cellpadding="1" cellspacing="2" width="100%">
	<tr>
		<td colspan="8" align="center"><cfoutput><strong>#session.Enombre#</strong></cfoutput></td>
	</tr>
	<tr>
		<td colspan="8" align="center"><cfoutput><strong>#LB_Titulo#</strong></cfoutput></td>
	</tr>
	<tr>
		<td colspan="8" align="center">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="8" align="center"><cfoutput>#titulos#</cfoutput></td>
	</tr>
	<tr>
		<td colspan="8" align="center">&nbsp;</td>
	</tr>
	<tr><cfoutput>
		<td><strong>#LB_Periodo#</strong></td>
		<td><strong>#LB_Lote#</strong></td>
		<td><strong>#LB_Asiento#</strong></td>
		<td><strong>#LB_Descripcion#</strong></td>
        <td><strong>#LB_Referencia#</strong></td>
        <td><strong>#LB_Documento#</strong></td>
		<td><strong>#LB_Fecha#</strong></td>
		<td><strong>#LB_Aplicacion#</strong></td>		
		<td align="right"><strong>#LB_Lineas#</strong></td>
		<td align="right"><strong>#LB_Monto#</strong></td>
        </cfoutput>
	</tr>
	<cfflush interval="120">
	<cfoutput query="rsLista">
		<tr>
			<td>#fecha#</td>
			<td>#Cconcepto#</td>
            <td>
				<cfif not isdefined("form.download")>
                	<cfif isdefined("Form.intercomp")>
						<a href="SQLPolizaConta.cfm?IDcontable=#IDcontable#&intercomp=#Form.intercomp#">
                    <cfelse>
                    	<a href="SQLPolizaConta.cfm?IDcontable=#IDcontable#">
                    </cfif>
                </cfif><u>#Edocumento#</u></a>
            </td>
			<td>#Edescripcion#</td>
            <td>#Ereferencia#</td>
            <td>#Edocbase#</td>
			<td>#LSdateformat(Efecha, "DD/MM/YYYY")#</td>
			<td>#LSdateformat(fechaAplica, "DD/MM/YYYY")#</td>
			<td align="right">#NumberFormat(Lineas, ",0")#</td>
			<td align="right">#NumberFormat(Monto, ",9.00")#</td>
		</tr>
	</cfoutput>
</table>
</form>
