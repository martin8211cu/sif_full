<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfset checked    = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
<cfset unchecked  = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >
<cfset borrar 	  = "<input name=''imageField'' type=''image'' src=''../../imagenes/Borrar01_S.gif'' width=''16'' height=''16'' border=''0'' onclick=''javascript:changeFormActionforDetalles();''>">

<!---Combo de los datos Variables aun no asignados--->
<cfif URL.TipoConfig EQ 'DatoVariable'>
	<cfquery name="DatoAconfigurar" datasource="#session.dsn#">
	   select dac.DVid as llave,dac.DVcodigo #_Cat#'-'#_Cat# dac.DVdescripcion as description
		   from DVdatosVariables dac
		where Ecodigo= #session.Ecodigo# and not exists (select 1 from DVconfiguracionTipo conf where conf.DVid = dac.DVid and conf.DVTcodigoValor = 'OF')
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
		where not exists (select 1 from DVconfiguracionTipo conf where conf.TEVid = dac.TEVid and conf.DVTcodigoValor = 'OF' )
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
<cfif url.DVTcodigo EQ 'OF'>
	<cfif URL.TipoConfig EQ 'DatoVariable'>
		<cfset title= "Configuración de Datos Variables para todas las Oficinas">
	<cfelse>
		<cfset title= "Configuración de Eventos para todas las Oficinas">
	</cfif>
	<cfset dvHabilitados = "Ecodigo= #session.Ecodigo#">
	<cfset FiltroConf = "and conf.DVTcodigo = 'OF'">
	<cfset CamposConfiguracion = "&nbsp;">
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