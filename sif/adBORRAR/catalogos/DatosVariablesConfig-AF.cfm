<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfset checked    = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
<cfset unchecked = "<img border=0 src=/cfmx/sif/imagenes/unchecked.gif>" >
<cfset borrar 	 = "<input name=''imageField'' type=''image'' src=''../../imagenes/Borrar01_S.gif'' width=''16'' height=''16'' border=''0'' onclick=''javascript:changeFormActionforDetalles();''>">

<!---Combo de los datos Variables aun no asignados--->
<cfif URL.TipoConfig EQ 'DatoVariable'>
	<cfquery name="DatoAconfigurar" datasource="#session.dsn#">
	   select dac.DVid as llave,dac.DVcodigo #_Cat#'-'#_Cat# dac.DVdescripcion as description
		   from DVdatosVariables dac
		where Ecodigo= #session.Ecodigo# and not exists (select 1 from DVconfiguracionTipo conf where conf.DVid = dac.DVid and conf.DVTcodigoValor = 'AF')
	</cfquery>
	<cfset labelCampo  	 	 = "Dato Variable">
	<cfset OtherTables       = "inner join DVdatosVariables dv on conf.DVid = dv.DVid
								left join ACategoria ac on conf.DVCidTablaCnf = ac.ACatId
								left join AClasificacion acl on conf.DVCidTablaCnf = acl.AClaId
								left join ACategoria ac2 on ac2.Ecodigo = acl.Ecodigo and 
ac2.ACcodigo = acl.ACcodigo"> 
	<cfset OtherColumns  	 = ",dv.DVid id_List , dv.DVcodigo as codigo, dv.DVdescripcion as description, 
						       case when dv.DVobligatorio = 0 then '#unchecked#' else '#checked#' end as DVobligatorio,
						       case when  DVtipoDato = 'C'  then 'Caracter' 
							   when  DVtipoDato = 'N' then 'Numerico' 
							   when  DVtipoDato = 'L' then 'Lista' 
							   when  DVtipoDato = 'F' then 'Fecha' 
							   when  DVtipoDato = 'H' then 'Hora' 
							   when  DVtipoDato = 'K' then 'Logico' 
							   else 'otro' end as DVtipoDato,
							   ac.ACdescripcion Categoria,
							   ac2.ACdescripcion Categoria2,
							   acl.ACdescripcion Clase">
	<cfset OtherColumnslist  = "DVtipoDato, DVobligatorio,">							 
	<cfset OtherFormat	     = "S,U,">
	<cfset Otheralign	 	 = "left,left,">
	<cfset Otherlabel	 	 = "Tipo,Obligatorio,">

<cfelseif URL.TipoConfig EQ 'Evento'>
	<cfquery name="DatoAconfigurar" datasource="#session.dsn#">
		select dac.TEVid as llave, dac.TEVcodigo #_Cat#'-'#_Cat# dac.TEVDescripcion as description
			from TipoEvento dac
		where not exists (select 1 from DVconfiguracionTipo conf where conf.TEVid = dac.TEVid and conf.DVTcodigoValor = 'AF' )
	</cfquery>
	<cfset labelCampo    	= "Evento">
	<cfset OtherTables   	= "inner join TipoEvento tv on conf.TEVid = tv.TEVid 
							   left join ACategoria ac on conf.DVCidTablaCnf = ac.ACatId
							   left join AClasificacion acl on conf.DVCidTablaCnf = acl.AClaId
							   left join ACategoria ac2 on ac2.Ecodigo = acl.Ecodigo and ac2.ACcodigo = acl.ACcodigo"> 
	<cfset OtherColumns  	= ",tv.TEVid id_List , tv.TEVcodigo as codigo, tv.TEVDescripcion as description, ac.ACdescripcion Categoria,
							   ac2.ACdescripcion Categoria2,
							   acl.ACdescripcion Clase">
	<cfset OtherColumnslist = "">
	<cfset OtherFormat	 	= "">
	<cfset Otheralign	 	= "">
	<cfset Otherlabel	 	= "">
<cfelse>
	ERROR: Tipo de Configuración no Implementada
	<cfabort>
</cfif>

<!---Configuración de Datos Variables y Eventos para todos los Activos Fijos--->
<cfif url.DVTcodigo EQ 'AF'>
	<cfif URL.TipoConfig EQ 'DatoVariable'>
		<cfset title= "Configuración de Datos Variables para todos los Activos Fijos">
	<cfelse>
		<cfset title= "Configuración de Eventos para todos los Activos Fijos">
	</cfif>
	<cfset dvHabilitados = "Ecodigo= #session.Ecodigo#">
	<cfset FiltroConf = "and conf.DVTcodigo = 'AF'">
	<cfset CamposConfiguracion = "&nbsp;">
	
<!---Configuración de Datos Variables para Activos Fijos por Categoria--->
<cfelseif url.DVTcodigo EQ 'AF_CATEGOR'> 
	<cfif URL.TipoConfig EQ 'DatoVariable'>
		<cfset title= 'Configuración de Datos Variables para Activos Fijos por Categoria'>		
	<cfelse>
		<cfset title= 'Configuración de Eventos para Activos Fijos por Categoria'>
	</cfif>
	
	<cfset FiltroConf = "and conf.DVTcodigo = 'AF_CATEGOR'">
	<cfset OtherColumnslist  &= "Categoria,">							 
	<cfset OtherFormat	     &= "S,">
	<cfset Otheralign	 	 &= "center,">
	<cfset Otherlabel	 	 &= "Categoria,">

	<cfsavecontent variable="CamposConfiguracion">
		<tr>
			<td align="right"><strong>Categor&iacute;a:</strong>&nbsp;</td>
			<td>
			<cfset ValuesArray=ArrayNew(1)>
				<cf_conlis
					Campos="DVCidTablaCnf, ACcodigodesc, ACdescripcion"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,40"
					<!---ValuesArray="#ValuesArray#"--->
					Title="Lista de Categorías"
					Tabla="ACategoria a"
					Columnas="ACatId DVCidTablaCnf, ACcodigodesc,ACdescripcion"
					Filtro="Ecodigo = #Session.Ecodigo# order by ACcodigodesc, ACdescripcion"
					Desplegar="ACcodigodesc, ACdescripcion"
					Etiquetas="Código,Descripción"
					filtrar_por="ACcodigodesc, ACdescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="DVCidTablaCnf, ACcodigodesc, ACdescripcion"
					Asignarformatos="I,S,S"
					tabindex="1" />
			</td>
		</tr>	
				
		<cfif URL.TipoConfig EQ 'DatoVariable'>
			<cfset dvHabilitados = "Ecodigo= #session.Ecodigo# and not exists (select 1 from DVconfiguracionTipo where DVid = a.DVid and DVTcodigo  = 'AF') and DVid not in (select DVid from DVconfiguracionTipo where DVid = a.DVid and DVCidTablaCnf = $DVCidTablaCnf,numeric$ and DVTcodigo = 'AF_CATEGOR')">		
		<cfelse>
			<cfset dvHabilitados = "Ecodigo= #session.Ecodigo# and not exists (select 1 from DVconfiguracionTipo where TEVid = a.TEVid and DVTcodigo  = 'AF') and TEVid not in (select TEVid from DVconfiguracionTipo where TEVid = a.TEVid and DVCidTablaCnf = $DVCidTablaCnf,numeric$ and DVTcodigo = 'AF_CATEGOR')">
		</cfif>		
		
		<!---<cfset filtroDV = "">--->
	</cfsavecontent>
<!---Configuración de Datos Variables para Activos Fijos por Categoria/Clase--->
<cfelseif url.DVTcodigo EQ 'AF_CLASIFI'> 
	<cfif URL.TipoConfig EQ 'DatoVariable'>
		<cfset title= 'Configuración de Datos Variables para Activos Fijos por Categoria/Clase'>
	<cfelse>
		<cfset title= 'Configuración de Eventos para Activos Fijos por Categoria/Clase'>
	</cfif>	
	<cfset FiltroConf = "and conf.DVTcodigo = 'AF_CLASIFI'">
	<cfset OtherColumnslist  &= "Categoria2,Clase,">							 
	<cfset OtherFormat	     &= "S,S,">
	<cfset Otheralign	 	 &= "center,center,">
	<cfset Otherlabel	 	 &= "Categoria,Clase,">
	<cfsavecontent variable="CamposConfiguracion">
		<tr>
			<td align="right"><strong>Categoría:</strong>&nbsp;</td>
			<td>
				<cfset ValuesArray=ArrayNew(1)>
				<cf_conlis
					Campos="ACcodigo, ACcodigodesc, ACdescripcion,ACatId"
					Desplegables="N,S,S,N"
					Modificables="N,S,N,N"
					Size="0,10,40,0"
					<!---ValuesArray="#ValuesArray#"--->
					Title="Lista de Categorías"
					Tabla="ACategoria a"
					Columnas="ACcodigo, ACcodigodesc,ACdescripcion,ACatId"
					Filtro="Ecodigo = #Session.Ecodigo# order by ACcodigodesc, ACdescripcion"
					Desplegar="ACcodigodesc, ACdescripcion"
					Etiquetas="Código,Descripción"
					filtrar_por="ACcodigodesc, ACdescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="ACcodigo, ACcodigodesc, ACdescripcion, ACatId"
					Asignarformatos="I,S,S,I"
					tabindex="2" 
					/>
			</td>
		</tr>
		<tr>
			<td align="right" valign="middle"><strong>Clase:</strong>&nbsp;</td>
			<td>
				<cf_conlis
					Campos="DVCidTablaCnf, ACcodigodescClas, ACdescripcionClas"
					Desplegables="N,S,S"
					Modificables="N,S,N"
					Size="0,10,40"
					<!---ValuesArray="#ValuesArray#"--->
					Title="Lista de Clases"
					Tabla="AClasificacion a" 
					Columnas="AClaId DVCidTablaCnf, ACcodigodesc ACcodigodescClas, ACdescripcion ACdescripcionClas"
					Filtro="Ecodigo = #Session.Ecodigo# and ACcodigo = $ACcodigo,numeric$ order by ACcodigodesc, ACdescripcion"
					Desplegar="ACcodigodescClas, ACdescripcionClas"
					Etiquetas="Código,Descripción"
					filtrar_por="ACcodigodesc, ACdescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="DVCidTablaCnf, ACcodigodescClas,ACdescripcionClas"
					Asignarformatos="I,S,S"
					debug="false"
					left="250"
					top="150"
					width="500"
					height="300"
					tabindex="2" />
			</td>
		</tr>
		<!---<cfset dvHabilitados = "not exists (select 1 from DVconfiguracionTipo where DVid = a.DVid and DVTcodigo = 'AF') and not exists (select 1 from DVconfiguracionTipo where DVid = a.DVid and DVCidTablaCnf = $DVCidTablaCnf,numeric$ and DVTcodigo = 'AF_CATEGOR')">--->
		
		
		<cfif URL.TipoConfig EQ 'DatoVariable'>
			<cfset dvHabilitados = "Ecodigo= #session.Ecodigo# and not exists (select 1 from DVconfiguracionTipo where DVid = a.DVid and DVTcodigo  = 'AF') 
			and DVid not in (select DVid from DVconfiguracionTipo where DVid = a.DVid and DVCidTablaCnf = $DVCidTablaCnf,numeric$ and DVTcodigo = 'AF_CLASIFI')
			and DVid not in (select DVid from DVconfiguracionTipo where DVid = a.DVid and DVCidTablaCnf = $ACatId,numeric$ and DVTcodigo = 'AF_CATEGOR')
			">
		<cfelse>
			<cfset dvHabilitados = "Ecodigo= #session.Ecodigo# and not exists (select 1 from DVconfiguracionTipo where TEVid = a.TEVid and DVTcodigo  = 'AF') 
			and TEVid not in (select TEVid from DVconfiguracionTipo where TEVid = a.TEVid and DVCidTablaCnf = $DVCidTablaCnf,numeric$ and DVTcodigo = 'AF_CLASIFI')
			and TEVid not in (select TEVid from DVconfiguracionTipo where TEVid = a.TEVid and DVCidTablaCnf = $ACatId,numeric$ and DVTcodigo = 'AF_CATEGOR')
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
	<!---<cfif URL.TipoConfig EQ 'Evento' or url.DVTcodigo EQ 'AF'>
		<tr>
			<td><cfoutput>#labelCampo#</cfoutput>:</td>
			<td>
			  <select name="DatoAconfigurar">
				<cfloop query="DatoAconfigurar">
					<option value="<cfoutput>#DatoAconfigurar.llave#</cfoutput>"><cfoutput>#DatoAconfigurar.description#</cfoutput></option>
				</cfloop>
			  </select>
			</td>
		</tr>
	</cfif>--->
	
	<cfif URL.TipoConfig EQ 'DatoVariable' <!---and url.DVTcodigo NEQ 'AF'--->>		
			<tr>
			<td align="right" valign="middle"><strong>Dato Variable:</strong>&nbsp;</td>
			<td>
				<cf_conlis
					Campos="DatoAconfigurar,DVcodigo,DVdescripcion"
					Desplegables="N,S,S"  
					Modificables="N,S,N"
					Size="0,10,40"
					<!---ValuesArray="#ValuesArray#"--->
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
		
		<cfif URL.TipoConfig EQ 'Evento' <!---and url.DVTcodigo NEQ 'AF'--->>		
			<tr>
			<td align="right" valign="middle"><strong>Evento:</strong>&nbsp;</td>
			<td>
				<cf_conlis
					Campos="DatoAconfigurar, TEVcodigo, TEVDescripcion"
					Desplegables="N,S,S"  
					Modificables="N,S,N"
					Size="0,10,40"
					<!---ValuesArray="#ValuesArray#"--->
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
	  <cfif ListFind('AF_CATEGOR,AF_CLASIFI', url.DVTcodigo)>
	  	<!---<cf_qformsRequiredField name="ACcodigodesc" description="Categoría">--->
		<cf_qformsRequiredField name="DVCidTablaCnf" description="Categoría">
	 </cfif>
	 <cfif ListFind('AF_CLASIFI', url.DVTcodigo)>
	  	<!---<cf_qformsRequiredField name="ACcodigodescClas" description="Clase">--->
		<cf_qformsRequiredField name="DVCidTablaCnf" description="Categoría y de Clase">
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