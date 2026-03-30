<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfset checked    = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
<cfset unchecked  = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >
<cfset borrar 	  = "<input name=''imageField'' type=''image'' src=''../../imagenes/Borrar01_S.gif'' width=''16'' height=''16'' border=''0'' onclick=''javascript:changeFormActionforDetalles();''>">

<!---Combo de los datos Variables aun no asignados--->
<cfif URL.TipoConfig EQ 'DatoVariable'>
	<cfquery name="DatoAconfigurar" datasource="#session.dsn#">
	   select dac.DVid as llave,dac.DVcodigo #_Cat#'-'#_Cat# dac.DVdescripcion as description
		   from DVdatosVariables dac
		where Ecodigo= #session.Ecodigo# and not exists (select 1 from DVconfiguracionTipo conf where conf.DVid = dac.DVid and conf.DVTcodigoValor = 'FA')
	</cfquery>
	<cfset labelCampo  	 	 = "Dato Variable">
	<cfset OtherTables       = "inner join DVdatosVariables dv on conf.DVid = dv.DVid
								left outer join Conceptos c on conf.DVCidTablaCnf = c.Cid
								left outer join CConceptos cc on conf.DVCidTablaCnf = cc.CCid
								"> 
                                
	<cfset OtherColumns  	 = ",dv.DVid id_List , dv.DVcodigo as codigo, dv.DVdescripcion as description, 
						       case when dv.DVobligatorio = 0 then '#unchecked#' else '#checked#' end as DVobligatorio,
						       case when  DVtipoDato = 'C'  then 'Caracter' 
							   when  DVtipoDato = 'N' then 'Numerico' 
							   when  DVtipoDato = 'L' then 'Lista' 
							   when  DVtipoDato = 'F' then 'Fecha' 
							   when  DVtipoDato = 'H' then 'Hora' 
							   when  DVtipoDato = 'K' then 'Logico' 
							   else 'otro' end as DVtipoDato,
							   c.Cdescripcion Concepto,
							   cc.CCdescripcion Clasificacion">
	<cfset OtherColumnslist  = "DVtipoDato, DVobligatorio,">							 
	<cfset OtherFormat	     = "S,U,">
	<cfset Otheralign	 	 = "left,left,">
	<cfset Otherlabel	 	 = "Tipo,Obligatorio,">

<cfelseif URL.TipoConfig EQ 'Evento'>
	<cfquery name="DatoAconfigurar" datasource="#session.dsn#">
		select dac.TEVid as llave, dac.TEVcodigo #_Cat#'-'#_Cat# dac.TEVDescripcion as description
			from TipoEvento dac
		where not exists (select 1 from DVconfiguracionTipo conf where conf.TEVid = dac.TEVid and conf.DVTcodigoValor = 'FA' )
	</cfquery>
	<cfset labelCampo    	= "Evento">
	<cfset OtherTables   	= "inner join TipoEvento tv on conf.TEVid = tv.TEVid 
							   left join Conceptos c on conf.DVCidTablaCnf = c.Cid
							   left join CConceptos cc on conf.DVCidTablaCnf = c.CCid
							   left join Conceptos c2 on c2.Ecodigo = c.Ecodigo and c2.Ccodigo = c.Ccodigo"> 
	<cfset OtherColumns  	= ",tv.TEVid id_List , tv.TEVcodigo as codigo, tv.TEVDescripcion as description, c.Cdescripcion Concepto,
							   c2.Cdescripcion Concepto2,
							   cc.CCdescripcion Clasificacion">
	<cfset OtherColumnslist = "">
	<cfset OtherFormat	 	= "">
	<cfset Otheralign	 	= "">
	<cfset Otherlabel	 	= "">
<cfelse>
	ERROR: Tipo de Configuración no Implementada
	<cfabort>
</cfif>

<!---Configuración de Datos Variables y Eventos para todos los Activos Fijos--->
<cfif url.DVTcodigo EQ 'FA'>
	<cfif URL.TipoConfig EQ 'DatoVariable'>
		<cfset title= "Configuración de Datos Variables para todas las Transacciones">
	<cfelse>
		<cfset title= "Configuración de Eventos para todas las Transacciones">
	</cfif>
	<cfset dvHabilitados = "Ecodigo= #session.Ecodigo#">
	<cfset FiltroConf = "and conf.DVTcodigo = 'FA'">
	<cfset CamposConfiguracion = "&nbsp;">
	
<!---Configuración de Datos Variables para Activos Fijos por Categoria--->
<cfelseif url.DVTcodigo EQ 'FA_CLASIF'> 
	<cfif URL.TipoConfig EQ 'DatoVariable'>
		<cfset title= 'Configuración de Datos Variables para la Clasificaci&oacute;n de Servicios'>		
	<cfelse>
		<cfset title= 'Configuración de Eventos para la Clasificaci&oacute;n de Servicios'>
	</cfif>
	
	<cfset FiltroConf = "and conf.DVTcodigo = 'FA_CLASIF'">
	<cfset OtherColumnslist  &= "Clasificacion,">							 
	<cfset OtherFormat	     &= "S,">
	<cfset Otheralign	 	 &= "center,">
	<cfset Otherlabel	 	 &= "Clasificacion,">

	<cfsavecontent variable="CamposConfiguracion">
		<tr>
			<td align="right"><strong>Clasificaci&oacute;n:</strong>&nbsp;</td>
			<td>
			<cfset ValuesArray=ArrayNew(1)>
				<cf_conlis
					Campos="DVCidTablaCnf, CCcodigo, CCdescripcion"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,40"
					Title="Lista de Clasificaciones de Servicios"
					Tabla="CConceptos a"
					Columnas="CCid DVCidTablaCnf, CCcodigo,CCdescripcion"
					Filtro="Ecodigo = #Session.Ecodigo# order by CCcodigo, CCdescripcion"
					Desplegar="CCcodigo, CCdescripcion"
					Etiquetas="Código,Descripción"
					filtrar_por="CCcodigo, CCdescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="DVCidTablaCnf, CCcodigo, CCdescripcion"
					Asignarformatos="I,S,S"
					tabindex="1" />
			</td>
		</tr>	
				
		<cfif URL.TipoConfig EQ 'DatoVariable'>
			<cfset dvHabilitados = "Ecodigo= #session.Ecodigo# and not exists (select 1 from DVconfiguracionTipo where DVid = a.DVid and DVTcodigo  = 'FA') and DVid not in (select DVid from DVconfiguracionTipo where DVid = a.DVid and DVCidTablaCnf = $DVCidTablaCnf,numeric$ and DVTcodigo = 'FA_CLASIF')">		
		<cfelse>
			<cfset dvHabilitados = "Ecodigo= #session.Ecodigo# and not exists (select 1 from DVconfiguracionTipo where TEVid = a.TEVid and DVTcodigo  = 'FA') and TEVid not in (select TEVid from DVconfiguracionTipo where TEVid = a.TEVid and DVCidTablaCnf = $DVCidTablaCnf,numeric$ and DVTcodigo = 'FA_CLASIF')">
		</cfif>		
		
		<!---<cfset filtroDV = "">--->
	</cfsavecontent>
<!---Configuración de Datos Variables para Activos Fijos por Categoria/Clase--->
<cfelseif url.DVTcodigo EQ 'FA_CONCEP'> 
	<cfif URL.TipoConfig EQ 'DatoVariable'>
		<cfset title= 'Configuración de Datos Variables para Conceptos de Servicio'>
	<cfelse>
		<cfset title= 'Configuración de Eventos para Conceptos de Servicio'>
	</cfif>	
	<cfset FiltroConf = "and conf.DVTcodigo = 'FA_CONCEP'">
	<cfset OtherColumnslist  &= "Concepto,">							 
	<cfset OtherFormat	     &= "S,">
	<cfset Otheralign	 	 &= "center,">
	<cfset Otherlabel	 	 &= "Concepto,">
	<cfsavecontent variable="CamposConfiguracion">
		<tr>
			<td align="right"><strong>Concepto:</strong>&nbsp;</td>
			<td>
				<cfset ValuesArray=ArrayNew(1)>
				<cf_conlis
					Campos="Ccodigo, Cdescripcion, DVCidTablaCnf, CCid"
					Desplegables="S,S,N,N"
					Modificables="S,N,N,N"
					Size="10,40,0,0"
					Title="Lista de Conceptos de Servicio"
					Tabla="Conceptos a"
					Columnas="Ccodigo, Cdescripcion, Cid DVCidTablaCnf, CCid"
					Filtro="Ecodigo = #Session.Ecodigo# order by Ccodigo, Cdescripcion"
					Desplegar="Ccodigo, Cdescripcion"
					Etiquetas="Código,Descripción"
					filtrar_por="Ccodigo, Cdescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="Ccodigo, Cdescripcion, DVCidTablaCnf, CCid"
					Asignarformatos="S,S,N,N"
					tabindex="2" 
					/>
			</td>
		</tr>
		
		<!---<cfset dvHabilitados = "not exists (select 1 from DVconfiguracionTipo where DVid = a.DVid and DVTcodigo = 'AF') and not exists (select 1 from DVconfiguracionTipo where DVid = a.DVid and DVCidTablaCnf = $DVCidTablaCnf,numeric$ and DVTcodigo = 'AF_CATEGOR')">--->
		
		
		<cfif URL.TipoConfig EQ 'DatoVariable'>
			<cfset dvHabilitados = "Ecodigo= #session.Ecodigo# and not exists (select 1 from DVconfiguracionTipo where DVid = a.DVid and DVTcodigo  = 'FA') 
			and DVid not in (select DVid from DVconfiguracionTipo where DVid = a.DVid and DVCidTablaCnf = $CCid,numeric$ and DVTcodigo = 'FA_CLASIF')
			and DVid not in (select DVid from DVconfiguracionTipo where DVid = a.DVid and DVCidTablaCnf = $DVCidTablaCnf,numeric$ and DVTcodigo = 'FA_CONCEP')
			">
		<cfelse>
			<cfset dvHabilitados = "Ecodigo= #session.Ecodigo# and not exists (select 1 from DVconfiguracionTipo where TEVid = a.TEVid and DVTcodigo  = 'FA') 
			and TEVid not in (select TEVid from DVconfiguracionTipo where TEVid = a.TEVid and DVCidTablaCnf = $CCid,numeric$ and DVTcodigo = 'FA_CLASIF')
			and TEVid not in (select TEVid from DVconfiguracionTipo where TEVid = a.TEVid and DVCidTablaCnf = $Cid,numeric$ and DVTcodigo = 'FA_CONCEP')
			">
		</cfif>	 
		
		<!---<cfset filtroDV = "and exists (select 1 from DVconfiguracionTipo conf where DVconfiguracionTipo.DVCidTablaCnf = $AClaId,numeric$ )">--->		
	</cfsavecontent>
</cfif>
<!---Lista de las configuraciones Actuales--->

<cfquery name="ListadoConfigurado" datasource="#session.dsn#">
    select DVCidTablaCnf DVCidTablaCnf_List, '#borrar#' as Borrar 
	  #preservesinglequotes(OtherColumns)#			
	 from DVconfiguracionTipo conf
		#preservesinglequotes(OtherTables)#
	where 1=1
	#preservesinglequotes(FiltroConf)#  
</cfquery>

<fieldset><legend><cfoutput>#title#</cfoutput></legend>
<table width="100%" border="0" cellspacing="1" cellpadding="1">
	
	
		<cfoutput>#CamposConfiguracion#</cfoutput>
		<tr><td>&nbsp;</td>
	    </tr>
	
	<tr><td colspan="2">
		<input type="hidden" name="DVTcodigo" value="<cfoutput>#url.DVTcodigo#</cfoutput>">
	</td></tr>
	
	<cfif URL.TipoConfig EQ 'DatoVariable' <!---and url.DVTcodigo NEQ 'FA'--->>		
			<tr>
			<td align="right" valign="middle"><strong>Dato Variable:</strong>&nbsp;</td>
			<td>
				<cf_conlis
					Campos="DatoAconfigurar,DVcodigo,DVdescripcion"
					Desplegables="N,S,S"  
					Modificables="N,S,N"
					Size="0,10,40"
					Title="Lista de Datos Variables"
					Tabla="DVdatosVariables a"
					Columnas="a.DVid DatoAconfigurar,a.DVcodigo,a.DVdescripcion"
					Filtro="#dvHabilitados#"
					Desplegar="DVcodigo,DVdescripcion"
					Etiquetas="Código,Descripción"
					filtrar_por="DVcodigo,DVdescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="DatoAconfigurar,DVcodigo,DVdescripcion"
					Asignarformatos="I,S,S"
					debug="false"
					left="250"
					top="150"
					width="500"
					height="300"
					tabindex="2" />
				</td>
			</tr>
		</cfif>
		
		<cfif URL.TipoConfig EQ 'Evento' <!---and url.DVTcodigo NEQ 'FA'--->>		
			<tr>
			<td align="right" valign="middle"><strong>Evento:</strong>&nbsp;</td>
			<td>
				<cf_conlis
					Campos="DatoAconfigurar, TEVcodigo, TEVDescripcion"
					Desplegables="N,S,S"  
					Modificables="N,S,N"
					Size="0,10,40"
					Title="Lista de Clases"
					Tabla="TipoEvento a"
					Columnas="a.TEVid DatoAconfigurar, a.TEVcodigo, a.TEVDescripcion"
					Filtro="#dvHabilitados#"
					Desplegar="TEVcodigo, TEVDescripcion"
					Etiquetas="Código,Descripción"
					filtrar_por="TEVcodigo, TEVDescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="DatoAconfigurar, TEVcodigo, TEVDescripcion"
					Asignarformatos="I,S,S"
					debug="false"
					left="250"
					top="150"
					width="500"
					height="300"
					tabindex="2" />
				</td>
			</tr>
		</cfif>
		
						
	<tr><td  colspan="2" align="center">
		<input type="submit" name="ALTA" value="Agregar" class="btnGuardar" />
	</td></tr>
		
	<tr><td colspan="2">
	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >	
		<cfinvokeargument name="query" 				value="#ListadoConfigurado#"/>
		<cfinvokeargument name="desplegar" 			value="codigo, description,#OtherColumnslist#  Borrar"/>
		<cfinvokeargument name="etiquetas" 			value="Codigo,Descripcion,#Otherlabel#,"/>
		<cfinvokeargument name="formatos" 			value="S,S,#OtherFormat#US"/>
		<cfinvokeargument name="align" 				value="left,left,#Otheralign#left"/>
		<cfinvokeargument name="formName" 			value="ValoreVariables"/>
		<cfinvokeargument name="checkboxes" 		value="N"/>
		<cfinvokeargument name="keys" 				value="id_List"/>
		<cfinvokeargument name="ira" 				value="DatosVariablesConfig.cfm"/>
		<cfinvokeargument name="MaxRows" 			value="10"/>
		<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
		<cfinvokeargument name="PageIndex" 			value="1"/>
		<cfinvokeargument name="formname" 			value="form1"/>	
		<cfinvokeargument name="incluyeForm2" 		value="false"/>
	</cfinvoke>
	</td></tr>
</table>
<cf_qforms>
      <cf_qformsRequiredField name="DatoAconfigurar" description="#labelCampo#">
	  <cfif ListFind('FA_CLASIF', url.DVTcodigo)>
	  	<!---<cf_qformsRequiredField name="ACcodigodesc" description="Categoría">--->
		<cf_qformsRequiredField name="DVCidTablaCnf" description="Clasificacion">
	 </cfif>
	 <cfif ListFind('FA_CONCEP', url.DVTcodigo)>
	  	<!---<cf_qformsRequiredField name="ACcodigodescClas" description="Clase">--->
		<cf_qformsRequiredField name="DVCidTablaCnf" description="Concepto">
	 </cfif>
</cf_qforms>
</fieldset>
<script language="JavaScript">
	// Cambia el Action del Form
		function changeFormActionforDetalles() {
			if (confirm('¿Desea Eliminar el Registro?')){
			deshabilitarValidacion();
			document.form1.action = "DatosVariablesConfig-sql.cfm?BAJA=true&TipoConfig=<cfoutput>#URL.TipoConfig#</cfoutput>";
			}
		}
</script>