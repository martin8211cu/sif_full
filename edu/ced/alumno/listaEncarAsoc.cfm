
	<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
		<cfparam name="Form.persona" default="#Url.persona#">
	</cfif>
	<cfif isdefined("Url.tab") and not isdefined("Form.tab")>
		<cfparam name="Form.tab" default="#Url.tab#">
	</cfif>

<!--- Consulta de Encargados --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsEcodigo">
		Select a.Ecodigo
		from Alumnos a
		inner join Estudiante b
		   on b.persona = a.persona
		  and b.Ecodigo = a.Ecodigo
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
	</cfquery>  

	<form action="SQLlistaEncarAsoc.cfm" method="post" name="formEncarAsoc">
		<cfoutput>
		<input name="persona" id="persona" value="<cfif isdefined("Form.persona") and Form.persona NEQ ''>#Form.persona#</cfif>" type="hidden"> 	
		<input name="EcodigoEst" id="EcodigoEst" type="hidden" value="#rsEcodigo.Ecodigo#">  <!--- --->	
		<input name="tab" id="tab" type="hidden" value="<cfif isdefined("Form.tab") and Form.tab NEQ ''>#form.tab#</cfif>"> 	
	  	<input type="hidden" name="EncarBajaEEcod" id="EncarBajaEEcod" value="" >
	  	<input type="hidden" name="EncarBajaEcod" id="EncarBajaEcod" value="" >	 
		<input name="Borra" type="hidden" id="Borra" value="">
		<!--- Campos del filtro para la lista de alumnos --->
		<cfif isdefined("Form.Filtro_Estado")>
			<input type="hidden" name="Filtro_Estado" value="#Form.Filtro_Estado#">
		</cfif>		   
		<cfif isdefined("Form.Filtro_Grado")>
			<input type="hidden" name="Filtro_Grado" value="#Form.Filtro_Grado#">
		</cfif>		
		<cfif isdefined("Form.Filtro_Ndescripcion")>
			<input type="hidden" name="Filtro_Ndescripcion" value="#Form.Filtro_Ndescripcion#">
		</cfif>		
		<cfif isdefined("Form.Filtro_Nombre")>
			<input type="hidden" name="Filtro_Nombre" value="#Form.Filtro_Nombre#">
		</cfif>
		<cfif isdefined("Form.Filtro_Pid")>
			<input type="hidden" name="Filtro_Pid" value="#Form.Filtro_Pid#">
		</cfif>
		<input type="hidden" name="NoMatr" value="<cfif isdefined("Form.NoMatr")>#Form.NoMatr#</cfif>">
		<input name="Pagina" type="hidden" value="#form.Pagina#">
		</cfoutput>
			<cfset navegacion=''>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<cfinvoke 
								 component="edu.Componentes.pListas"
								 method="pListaEdu"
								 returnvariable="pListaEncar">
									<cfinvokeargument name="tabla" value="EncargadoEstudiante a
																			inner join Alumnos b
																			   on a.CEcodigo = b.CEcodigo
																			  and a.Ecodigo = b.Ecodigo
																			inner join Estudiante c
																			   on b.Ecodigo = c.Ecodigo
																			inner join Encargado d
																			   on a.EEcodigo = d.EEcodigo
																			inner join PersonaEducativo e
																			   on d.persona = e.persona"/>
									<cfinvokeargument name="columnas" value="a.EEcodigo, e.persona as personaEncar,
																			a.CEcodigo, 
																			(Pnombre || ' ' || Papellido1 || ' ' || Papellido2) as NombreEnc,
																			Pid as PidEnc,
																			'<img border=''0'' src=''../../Imagenes/Stop01_T.gif'' width=''18'' height=''14'' border=''0'' align=''absmiddle''  onClick=''javascript: setBtn(this); 
																			borraEncar('||convert(varchar,a.EEcodigo)||','||convert(varchar,a.Ecodigo)||')''>' as Borrar"/> 
									<cfinvokeargument name="desplegar" 		value="PidEnc,NombreEnc,Borrar"/>
									<cfinvokeargument name="etiquetas" 		value="Identificaci&oacute;n, Nombre,Borrar"/>
									<cfinvokeargument name="formatos" 		value="S,S,U"/>
									<cfinvokeargument name="filtrar_por" 	value="Pid,Pnombre || ' ' || Papellido1 || ' ' || Papellido2,''"/>
									<cfinvokeargument name="filtro" 		value="a.CEcodigo=#Session.Edu.CEcodigo#
																					and b.persona=#form.persona#"/>
									<cfinvokeargument name="align" 			value="left,left,center"/>
									<cfinvokeargument name="ajustar" 		value="N"/>
									<cfinvokeargument name="irA" 			value="SQLlistaEncarAsoc.cfm"/>
									<cfinvokeargument name="navegacion" 	value="#navegacion#"/>
									<cfinvokeargument name="conexion" 		value="#Session.Edu.DSN#"/>
									<cfinvokeargument name="debug" 			value="N"/>
									<cfinvokeargument name="incluyeForm" 	value="false"/>
									<cfinvokeargument name="formName" 		value="formEncarAsoc"/>
									<cfinvokeargument name="botones"		value="Nuevo"/>
									<cfinvokeargument name="mostrar_filtro" value="true"/>
									<cfinvokeargument name="filtrar_automatico" value="true"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
								</cfinvoke>
						</td>
					</tr>
				</table>
			</form>  
  <script language="JavaScript" type="text/javascript">
  	function borraEncar(varEEcodigo, varEcodigo){
		var vEncarBajaEEcod = document.getElementById("EncarBajaEEcod");		
		var vEncarBajaEcod = document.getElementById("EncarBajaEcod");	
		var vBorra = document.getElementById("Borra");	

		if(confirm('Esta seguro(a) que desea borrar este encargado?')){
			vEncarBajaEEcod.value = varEEcodigo;
			vEncarBajaEcod.value = varEcodigo;		
			vBorra.value = 'si';
			return true;
		}else{
			vBorra.value = 'no';
			return false;
		}
	}
  </script>