
	<cfset keys = ''>
	<cfset columnas = ''>
	<cfset desplegar = ''>
	<cfset etiquetas = ''>
	<cfset formatos = ''>
	<cfset align = ''>
	<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="i">
		<cfset keys     = ListAppend (keys,     metadata.pk.cols[i].code)>
		<cfset columnas = ListAppend (columnas,     metadata.pk.cols[i].code)>
		<cfif Not metadata.pk.cols[i].identity>
			<cfset desplegar = ListAppend (desplegar,     metadata.pk.cols[i].code)>
			<cfset etiquetas = ListAppend (etiquetas, metadata.pk.cols[i].name)>
			<cfset formatos = ListAppend (formatos, 'S')>
			<cfset align    = ListAppend (align,    'left')>
		</cfif>
	</cfloop>
	<cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i">
		<cfif FindNoCase('descr', metadata.cols[i].code) Or 
			FindNoCase('nombr', metadata.cols[i].code) Or
			FindNoCase('codigo', metadata.cols[i].code)>
			<cfif Not ListFind('Ecodigo,CEcodigo,BMUsucodigo,BMfecha',metadata.cols[i].code)>
				<cfif Not ListFind(columnas, metadata.cols[i].code)>
					<cfset columnas = ListAppend (columnas,     metadata.cols[i].code)>
				</cfif>
				<cfif Not ListFind(desplegar, metadata.cols[i].code)>
					<cfset desplegar = ListAppend (desplegar,     metadata.cols[i].code)>
					<cfset etiquetas = ListAppend (etiquetas, metadata.cols[i].name)>
					<cfset formatos = ListAppend (formatos, 'S')>
					<cfset align    = ListAppend (align,    'left')>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	
	<cfset hayEcodigo = false>
	<cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i">
		<cfif metadata.cols[i].code is 'Ecodigo'>
			<cfset hayEcodigo = true>
		<cfelseif metadata.cols[i].code is 'CEcodigo'>
			<cfset hayCEcodigo = true>
		</cfif>
	</cfloop>
	<cfif hayEcodigo>
		<cfset filtroWhere = "Ecodigo = ##session.Ecodigo##">
	<cfelseif hayEcodigo>
		<cfset filtroWhere = "CEcodigo = ##session.CEcodigo##">
	<cfelse>
		<cfset filtroWhere = "1 = 1">
	</cfif>

<cfset isedit = ''>
<cfloop list="#keys#" index="akey">
	<cfset isedit = isedit & ' and IsDefined("url.' & akey & '")'>
	<cfset isedit = isedit & ' and Len(url.' & akey & ')'>
</cfloop>
<cfif Len(isedit)>
	<cfset isedit = Mid(isedit, 6, Len(isedit) - 5)>
</cfif>

<cfoutput>
#'<'#cf_templateheader title="Mantenimiento de #HTMLEditFormat(metadata.name)#">
#'<'#cf_web_portlet_start titulo="Mantenimiento de #HTMLEditFormat(metadata.name)#"/>

#'<'#cfif #isedit# or IsDefined("url.edit")>
	#'<'#cfinclude template="#metadata.code#-form.cfm">
#'<'#cfelse>
	#'<'#cfinvoke component="sif.Componentes.pListas" method="pLista"
		tabla="#metadata.code#"
		columnas="#columnas#"
		filtro="#filtroWhere# order by #desplegar#"
		desplegar="#desplegar#"
		etiquetas="#etiquetas#"
		formatos="#formatos#"
		align="#align#"
		ira="#metadata.code#.cfm"
		form_method="get"
		keys="#keys#"
		mostrar_filtro="yes"
		filtrar_automatico="yes"
		botones="Nuevo"
	/>
#'<'#/cfif>
#'<'#cf_web_portlet_end/>
#'<'#cf_templatefooter>
</cfoutput>
