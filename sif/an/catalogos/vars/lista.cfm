<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Nombre" 	default="Nombre" 
returnvariable="LB_Nombre" xmlfile="lista.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Descripcion" 	default="Descripci&oacute;n" 
returnvariable="LB_Descripcion" xmlfile="lista.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="BTN_Filtrar" 	default="Filtrar" 
returnvariable="BTN_Filtrar" xmlfile="lista.xml"/>

<cf_dbfunction name="to_char" args="AVdescripcion" returnvariable="AVdescripcion">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfquery name="rsAnexoVar" datasource="#session.dsn#">
	select AVid, AVnombre, rtrim(#PreserveSingleQuotes(AVdescripcion)#) AVdescripcion, AVtipo, ts_rversion, 
			case
				when <cf_dbfunction name="length" args="AVdescripcion"> > 50 
					then <cf_dbfunction name="sPart" args="rtrim(#PreserveSingleQuotes(AVdescripcion)#);1;50" delimiters=";"> #_Cat# '...'
			    else rtrim(#PreserveSingleQuotes(AVdescripcion)#)
			end as AVdescripcioncorta,
			case AVtipo 
					when 'C' then 'Caracter'
					when 'M' then 'Moneda'
					when 'F' then 'Flotante'
			end as AVtipodesc,
			case when AVusar_oficina = 1 then 'Variables por Oficina' else 'Variables por Empresa' end as Por_Oficina,
			case 
				when AVvalor_anual=1 and AVvalor_arrastrar=1 then 'Arr/Anu'
				when AVvalor_anual=1 and AVvalor_arrastrar=0 then 'Anual'
				when AVvalor_anual=0 and AVvalor_arrastrar=1 then 'Arras.'
			end as tipo
	from AnexoVar
	where CEcodigo = #session.cecodigo#
</cfquery>

<cfquery name="rsLista" dbtype="query">
	select AVid, AVtipo, AVtipodesc, AVnombre, AVdescripcioncorta, 
		Por_Oficina, tipo
	from rsAnexoVar
	where 1 = 1
	<cfif isdefined("form.filtro_AVnombre") and len(trim(form.filtro_AVnombre))>
		and upper(AVnombre) like '%#Ucase(form.filtro_AVnombre)#%'
	</cfif>
	<cfif isdefined("form.filtro_AVdescripcion") and len(trim(form.filtro_AVdescripcion))>
		and upper(AVdescripcion) like '%#Ucase(form.filtro_AVdescripcion)#%'
	</cfif>
	order by 6,2,3,4,5
</cfquery>
<cfoutput>
<form action="" method="post" name="filtro" style="margin:0px;">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
  <tr>
    <td class="titulolistas"><strong>#LB_Nombre#&nbsp;</strong></td>
		<td class="titulolistas"><strong>#LB_Descripcion#&nbsp;</strong></td>
		<td class="titulolistas"><strong>&nbsp;</strong></td>
  </tr>
  <tr>
    <td class="titulolistas"><input type="text" name="filtro_AVnombre" value="<cfif isdefined('form.filtro_AVnombre')>#form.filtro_AVnombre#</cfif>"></td>
		<td class="titulolistas"><input type="text" name="filtro_AVdescripcion" value="<cfif isdefined('form.filtro_AVdescripcion')>#form.filtro_AVdescripcion#</cfif>"></td>
		<td class="titulolistas"><input type="submit" name="filtro_boton" value="#BTN_Filtrar#"></td>
  </tr>
</table>
</form>	
</cfoutput>
<cfinvoke 
	component="sif.Componentes.pListas" 
	method="pListaQuery" 
	returnvariable="pListaAnexoVar"
	query="#rsLista#"
	cortes="Por_Oficina"
	desplegar="AVnombre, AVdescripcioncorta,AVtipodesc, tipo"
	etiquetas=""
	align="left,left,left,center"
	formatos="S,S,S,U"
	irA="index.cfm"
	showEmptyListMsg="true"
	usaAjax="no"
	/>