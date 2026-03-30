<cf_templateheader title="Control de Embarques">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Control de Tracking de Embarque'>
				
		<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
		<script language="JavaScript" type="text/javascript">
			var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}

			function doConlisTrackings(valor) {
				popUpWindow("/cfmx/sif/cm/proveedor/ConlisTrackings.cfm?ent=1&idx="+valor,30,100,950,500);
			}

			function limpiar() {
				document.form1.ETconsecutivo_move1.value = ''
				document.form1.ETconsecutivo_move2.value = ''
				document.form1.ETidtracking_move1.value = ''
				document.form1.ETidtracking_move2.value = ''
				document.form1.ETnumtracking_move1.value = ''
				document.form1.ETnumtracking_move2.value = ''
				document.form1.LEstados.value = ''
			}
		</script>
	<!--- Si estan definidos los filtros por URL --->		
	<cfif isdefined("url.ETconsecutivo_move1") and not isdefined("form.ETconsecutivo_move1") >
		<cfset form.ETconsecutivo_move1 = url.ETconsecutivo_move1 >
	</cfif>
	
	<cfif isdefined("url.ETconsecutivo_move2") and not isdefined("form.ETconsecutivo_move2") >
		<cfset form.ETconsecutivo_move2 = url.ETconsecutivo_move2 >
	</cfif>
	
	<cfif isdefined("url.ETidtracking_move1") and not isdefined("form.ETidtracking_move1") >
		<cfset form.ETidtracking_move1 = url.ETidtracking_move1 >
	</cfif>
	
	<cfif isdefined("url.ETnumtracking_move1") and not isdefined("form.ETnumtracking_move1") >
		<cfset form.ETnumtracking_move1 = url.ETnumtracking_move1 >
	</cfif>
	
	<cfif isdefined("url.ETnumtracking_move2") and not isdefined("form.ETnumtracking_move2") >
		<cfset form.ETnumtracking_move2 = url.ETnumtracking_move2 >
	</cfif>
	
	<cfif isdefined("url.LEstados") and not isdefined("form.LEstados") >
		<cfset form.LEstados = url.LEstados>
	</cfif>
	
	<!--- Establecer las variables de navegacion --->
	<cfset navegacion = "">
	
	<!--- Consecutivo del tracking ETconsecutivo --->
	<cfif isdefined("form.ETconsecutivo_move1") and len(trim(form.ETconsecutivo_move1)) >
		<cfset navegacion = navegacion & "&ETconsecutivo_move1=#form.ETconsecutivo_move1#">
	</cfif>
	<cfif isdefined("form.ETconsecutivo_move2") and len(trim(form.ETconsecutivo_move2)) >
		<cfset navegacion = navegacion & "&ETconsecutivo_move2=#form.ETconsecutivo_move2#">
	</cfif>
	
	<!--- Id del tracking ETidtracking ---->	
	<cfif isdefined("form.ETidtracking_move1") and len(trim(form.ETidtracking_move1)) >
		<cfset navegacion = navegacion & "&ETidtracking_move1=#form.ETidtracking_move1#">
	</cfif>	
	<cfif isdefined("form.ETidtracking_move2") and len(trim(form.ETidtracking_move2)) >
		<cfset navegacion = navegacion & "&ETidtracking_move2=#form.ETidtracking_move2#">
	</cfif>
	
	<!---- Numero de tracking Etnumtracking---->
	<cfif isdefined("form.ETnumtracking_move1") and len(trim(form.ETnumtracking_move1)) >
		<cfset navegacion = navegacion & "&ETnumtracking_move1=#form.ETnumtracking_move1#">
	</cfif>
	<cfif isdefined("form.ETnumtracking_move2") and len(trim(form.ETnumtracking_move2)) >
		<cfset navegacion = navegacion & "&ETnumtracking_move2=#form.ETnumtracking_move2#">
	</cfif>
	
	<!--- Estado del tracking ET--->
	<cfif isdefined("form.LEstados") and len(trim(form.LEstados)) >
		<cfset navegacion = navegacion & "&LEstados=#form.LEstados#">
	</cfif>
		
	<cfoutput>
	
	<!---action="seguimientoTracking.cfm" --->
	<form method="post" name="form1" action="seguimientoTrackingRango-filtro.cfm"> <!---onSubmit="javascript: return Valida()"> ---->
	  <cfinclude template="/sif/portlets/pNavegacion.cfm">
	  <table width="100%" border="0" cellspacing="0" cellpadding="1" align="center" class="areaFiltro">
			<!---<tr><td colspan="5"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td></tr>--->
			<tr><td>&nbsp;</td></tr>
			<tr>
			  	<td width="11%" align="right" nowrap><strong>&nbsp;Desde el Tracking:</strong></td>
			  	<td width="24%" nowrap>
					<input type="hidden" name="ETidtracking_move1" value="<cfif isdefined("form.ETidtracking_move1")>#form.ETidtracking_move1#</cfif>">
					<input type="text" size="10" name="ETconsecutivo_move1" value="<cfif isdefined("form.ETconsecutivo_move1")>#form.ETconsecutivo_move1#</cfif>" onblur="javascript:traeTracking(this.value,1); fm(this,-1)">
					<input type="text" size="30" readonly name="ETnumtracking_move1" value="<cfif isdefined("form.ETnumtracking_move1")>#form.ETnumtracking_move1#</cfif>">
					<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Trackings de Embarque" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisTrackings(1);'></a>&nbsp;					
				</td>
			  	<td width="10%"nowrap><strong>&nbsp;&nbsp;&nbsp;Hasta el Tracking:</strong></td>
				<td width="29%" nowrap>
					<input type="hidden" name="ETidtracking_move2" value="<cfif isdefined("form.ETidtracking_move2")>#form.ETidtracking_move2#</cfif>">
					<input type="text" size="10" name="ETconsecutivo_move2" value="<cfif isdefined("form.ETconsecutivo_move2")>#form.ETconsecutivo_move2#</cfif>" onblur="javascript:traeTracking(this.value,2); fm(this,-1)">										
					<input type="text" size="30" readonly name="ETnumtracking_move2" value="<cfif isdefined("form.ETnumtracking_move2")>#form.ETnumtracking_move2#</cfif>">
					<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Trackings de Embarque" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript:doConlisTrackings(2);'></a> 
				</td>
				<td width="26%" nowrap>
					<cfquery name="rsEstados" datasource="sifpublica">
						select ETcodigo, ETdescripcion
						from  EstadosTracking
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>	
					&nbsp;<strong>Estado:</strong>
					<select name="LEstados" id="LEstados">
						<option value="" selected>- No especificado -</option> 
							<cfloop query="rsEstados">
								<option value="#trim(rsEstados.ETcodigo)#" <cfif isdefined('form.LEstados') and (trim(rsEstados.ETcodigo) EQ trim(form.LEstados))>selected</cfif>>#HTMLEditFormat(rsEstados.ETdescripcion)#</option>
							</cfloop>
					</select>
				</td>				
			</tr>
			<tr><td colspan="5">&nbsp;</td></tr>
			<tr><td colspan="5" align="center">
				<input type="submit" value="Filtrar" name="Filtrar" id="Filtrar">&nbsp;	
				<input type="button" value="Limpiar" name="Filtrar" id="Filtrar" onClick="javascript:limpiar();">
			</td></tr>
			<tr>						
			  <td>&nbsp;</td>
			</tr>
      </table>
	</form>		

	<table width="100%" valign="top" align="center">
      <tr>
        <td colspan="6">
          <cfquery name="rsLista" datasource="sifpublica">
      		select 	a.ETidtracking as ETidtracking_move1, 
					a.ETnumtracking,
					a.ETconsecutivo, 
					a.ETfechagenerado, 
					a.ETfechaentrega, 
					b.ETdescripcion 
			from ETracking a 
				inner join EstadosTracking b 
					on a.ETcodigo= b.ETcodigo 
					and a.Ecodigo = b.Ecodigo 
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  <cfif isdefined("form.ETidtracking_move1") and len(trim(form.ETidtracking_move1)) and (isdefined("form.ETidtracking_move2") and len(trim(form.ETidtracking_move2)))>
				<cfif form.ETidtracking_move1 GT form.ETidtracking_move2>
				  	and a.ETidtracking between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move2#">
				  	and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move1#">
				  <cfelseif form.ETidtracking_move1 EQ form.ETidtracking_move2>
				  	and a.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move1#">
				  <cfelse>
				  	and ETidtracking between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move1#">
				  	and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move2#">
				</cfif>
				<cfelseif isdefined("form.ETidtracking_move1") and len(trim(form.ETidtracking_move1))>
					and ETidtracking >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move1#">
				<cfelseif isdefined("form.ETidtracking_move2") and len(trim(form.ETidtracking_move2))>
					and ETidtracking <=	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtracking_move2#">
			 </cfif>
			 <cfif isdefined("form.LEstados") and len(trim(form.LEstados)) >
				and a.ETcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.LEstados#">
			 </cfif>
			  	order by ETconsecutivo, ETdescripcion
			</cfquery>

			  <cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<!---<cfinvokeargument name="cortes" value="ETdescripcion"/>--->
				<cfinvokeargument name="desplegar" value="ETconsecutivo, ETnumtracking, ETfechagenerado, ETfechaentrega, ETdescripcion"/>
				<cfinvokeargument name="etiquetas" value="Tracking, N°Control, Fecha Generado, Fecha Entrega, Estado"/>
				<cfinvokeargument name="formatos" value="V,V, D, D, V"/>
				<cfinvokeargument name="align" value="left, left, left, left, left "/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="seguimientoTracking.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<!---<cfinvokeargument name="keys" value="ETidtracking_move1"/>--->
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="MaxRows" value="20"/>
				<!---<cfinvokeargument name="funcion" value="doConlis"/>--->
				<!---<cfinvokeargument name="fparams" value="ESidsolicitud,ESestado"/>--->
			  </cfinvoke>
        </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
      </tr>
    </table>
	</cfoutput>
    <!------->

<script language="JavaScript" type="text/javascript">		 
	function traeTracking(value, index){
	  if (value!=''){	   
	   document.getElementById("fr").src = 'traerTracking.cfm?todoEstado=1&ETconsecutivo='+value+'&index='+index;
	  }
	  else{
	   document.form1.ETidtracking_move1.value = '';
	   document.form1.ETconsecutivo_move1.value = '';
	   document.form1.ETnumtracking_move1.value = '';
	   
	   document.form1.ETidtracking_move2.value = '';
	   document.form1.ETconsecutivo_move2.value = '';
	   document.form1.ETnumtracking_move2.value = '';
	  }
	 }	 	
</script>	
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="10" width="10" scrolling="auto" src="" ></iframe>
<!------->		 	
		<cf_web_portlet_end>
	<cf_templatefooter>

