<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Interno"
	Default="Interno"
	returnvariable="LB_Interno"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Externo"
	Default="Externo"
	returnvariable="LB_Externo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReasignacionDePlazas"
	Default="Reasignación de Plazas"
	returnvariable="LB_ReasignacionDePlazas"/>

<cf_templatecss>
<cfif isdefined("url.RHCconcurso") and len(trim(url.RHCconcurso))>
	<cfset form.RHCconcurso = url.RHCconcurso>
</cfif>
<cfif isdefined("url.plazas") and len(trim(url.plazas))>
	<cfset vsTemp=FindNoCase(',',url.plazas,len(url.plazas))><!---Si viene coma al final--->
	<cfif vsTemp GT 0>		
		<cfset url.plazas = mid(url.plazas,1,len(url.plazas)-1)><!---Lista de plazas ya asignadas(quitar ultima coma)---->
	</cfif>
</cfif>
<!---Datos personales segun el tipo Interno o  Externo----->
<cfif url.tipo EQ 'I'>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select DEidentificacion as ident, 
			{fn concat(DEnombre,{fn concat(' ',{fn concat(DEapellido1,{fn concat(' ',DEapellido2)})})})}  as  Nombre
		from DatosEmpleado 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#listgetat(url.id,1,'_')#">
	</cfquery>	
<cfelseif url.tipo EQ 'E'>
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select RHOidentificacion as ident, 
			{fn concat(RHOnombre,{fn concat(' ',{fn concat(RHOapellido1,{fn concat(' ',RHOapellido2)})})})} as  Nombre
		from DatosOferentes 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#listgetat(url.id,1,'_')#">
	</cfquery>	
</cfif>
<!---Plazas NO asignadas--->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2119" default="" returnvariable="LvarAsigna"/><!---Me indica si asigno la misma plaza a varias personas--->
	<cf_translatedata name="get" tabla="RHPlazas" col="b.RHPdescripcion" returnvariable="LvarRHPdescripcion">
	<cfquery name="rsDisponibles" datasource="#session.DSN#">
		select b.RHPcodigo, #LvarRHPdescripcion# as RHPdescripcion, b.RHPid
		from RHPlazasConcurso a
		
		inner join RHPlazas b
		on a.Ecodigo = b.Ecodigo
		and a.RHPid = b.RHPid
		
		where RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCconcurso#">
		<cfif LvarAsigna eq 0>
			and b.RHPid not in ( select c.RHPid 
								 from RHAdjudicacion c
								 where c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								 and c.RHCconcurso=a.RHCconcurso
								 and c.RHAestado in (10,20) )
		</cfif>
	</cfquery>

	<cfquery name="rsLista" datasource="#session.DSN#">	
		select 	RHCconcurso,
				RHCPid, 
				RHCPtipo as tipo, 
				a.DEid as ID,
				(case RHCPtipo when 'I' then '#LB_Interno#' else '#LB_Externo#' end) as Tipo_Concursante,
				<cf_dbfunction name="to_char" args="a.RHCPpromedio"> as RHCPpromedio, RHCPpromedio as promedio,
				DEidentificacion as ident,
				{fn concat(b.DEnombre,{fn concat(' ',{fn concat(b.DEapellido1,{fn concat(' ',b.DEapellido2)})})})}  as  Nombre
		from RHConcursantes a , DatosEmpleado b
		where a.DEid  = b.DEid 
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCconcurso#" >
		  and a.RHCdescalifica = 0
	
		union
		
		select  RHCconcurso,
				RHCPid, 
				RHCPtipo as tipo, 
				a.RHOid as ID,
				(case RHCPtipo when 'E' then '#LB_Externo#' else '#LB_Interno#' end) as Tipo_Concursante,
				<cf_dbfunction name="to_char" args="a.RHCPpromedio"> as RHCPpromedio, RHCPpromedio as promedio,
				RHOidentificacion as ident,
				{fn concat(b.RHOnombre,{fn concat(' ',{fn concat(b.RHOapellido1,{fn concat(' ',b.RHOapellido2)})})})} as  Nombre
		from RHConcursantes a , DatosOferentes b
	
		where a.RHOid  = b.RHOid 
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHCconcurso =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCconcurso#">
		  and a.RHCdescalifica = 0
				
		order by promedio desc
	</cfquery>

<script type="text/javascript" language="javascript1.2">
	
	function linea(valor){
		resultado = valor.split('~');
		if (resultado.length >=1 ){
			return resultado[0];
		}
		return;
	}
	function limpialinea(valor){
		
		var resultado = valor.split('~');
		var valor2 = resultado[0];
		var lineaPl = '';
		<cfoutput query="rsLista">
			 lineaPl = '#rsLista.ID#_#rsLista.Tipo#';
				window.opener.document.formPaso1['RHPid_'+lineaPl].value = ''; 	// id
				window.opener.document.formPaso1['plaza_'+lineaPl].value = '';	// descripcion				 
		</cfoutput>
		   
		return true;
	}
	function descripcion(valor){
		resultado = valor.split('~');
		if (resultado.length >=2 ){
			return resultado[1];
		}
		return;
	}
	
	function buscar_plaza(){
		if (document.form1.opt && document.form1.opt.type) {
			valor = document.form1.opt.value;
		}
		else{
			for (var i = 0; i < document.form1.opt.length; i++) {
				if (document.form1.opt[i].checked){
					valor = document.form1.opt[i].value;
					break;
				}
			}
		}

		var _linea = linea(valor);
		 var _descripcion = descripcion(valor);
		
		<cfoutput query="rsLista">
			valor = '#rsLista.ID#_#rsLista.Tipo#';
		
			<!---  se cambio la llave de la busqueda de descripcion por codigo de la linea   --->
			if( window.opener.document.formPaso1['RHPid_'+valor].value == _linea ){ 
				window.opener.document.formPaso1['RHPid_'+valor].value = ''; 	// id
				window.opener.document.formPaso1['plaza_'+valor].value = '';	// descripcion
			}
			<!---  hace estaba antes 
			if( window.opener.document.formPaso1['plaza_'+valor].value == _descripcion ){
				window.opener.document.formPaso1['RHPid_'+valor].value = ''; 	// id
				window.opener.document.formPaso1['plaza_'+valor].value = '';	// descripcion
			}
			 --->
		</cfoutput>
	}
		
 	function funcModificar(){
		buscar_plaza()
		if (document.form1.opt.type) { //Si es solo un objeto option button
			if (document.form1.opt.checked){
				//var vsDesc = document.form1.opt.value.substring(document.form1.opt.value.indexOf('~')+1,document.form1.opt.length)//Codigo y descripcion de la plaza (RHPcodigo,RHPdescripcion)
				//var vsId = document.form1.opt.value.substring(0,document.form1.opt.value.indexOf('~'))//Id de la plaza (RHPid)
				
				var vsId = linea(document.form1.opt.value);
				var vsDesc = descripcion(document.form1.opt.value);
				
				var t= window.opener.document.formPaso1.plaza_<cfoutput>#url.id#</cfoutput>.value = vsDesc;//Se asignan en la pantalla que llama al popup
				
				window.opener.document.formPaso1.RHPid_<cfoutput>#url.id#</cfoutput>.value = vsId;				
				//Actualizar la lista (input) con las  plazas ya asignadas	
				<cfif isdefined("url.pasignada") and len(trim(url.pasignada))>
					var vsplazas = window.opener.document.formPaso1.pAsignadas.value.split(',');
					var vsasignada = <cfoutput>'#url.pasignada#'</cfoutput> //Plaza asignada
					window.opener.document.formPaso1.pAsignadas.value = ''						
					for (i=0; i < vsplazas.length;i++){//Recorrer el input con las ya asignadas
						if(vsplazas[i] == vsasignada || vsplazas[i] == vsId){ //Reemplazar la que se va a modificar por la nueva
							if (window.opener.document.formPaso1.pAsignadas.value ==''){//Si no hay asignadas
								window.opener.document.formPaso1.pAsignadas.value = vsId
							}
							else{//Si ya hay asignadas agrega la coma
								window.opener.document.formPaso1.pAsignadas.value = window.opener.document.formPaso1.pAsignadas.value+','+vsId
							}	
						}
						else if (window.opener.document.formPaso1.pAsignadas.value ==''){//Si la no es la que se va a modificar se carga de nuevo en el input
							if (window.opener.document.formPaso1.pAsignadas.value ==''){//Si no hay asignadas
								window.opener.document.formPaso1.pAsignadas.value = vsplazas[i]
							}
							else{//Si ya hay asignadas agrega la coma							
								window.opener.document.formPaso1.pAsignadas.value = window.opener.document.formPaso1.pAsignadas.value+','+vsplazas[i]
							}
						}
						///*-/*/-*/-*/-*/-*/-*/ Si se cierra la ventana automaticamente no hace falta /*/-*/-*/-*/-*/-*
						else {
							if (window.opener.document.formPaso1.pAsignadas.value ==''){//Si no hay asignadas
								window.opener.document.formPaso1.pAsignadas.value = vsId
							}
							else{//Si ya hay asignadas agrega la coma
								window.opener.document.formPaso1.pAsignadas.value = window.opener.document.formPaso1.pAsignadas.value+','+vsplazas[i]
							}	
						}
					}
				<cfelse>							
					if(window.opener.document.formPaso1.pAsignadas.value !=''){//Si ya hay plazas asignadas agregar la coma
						window.opener.document.formPaso1.pAsignadas.value = window.opener.document.formPaso1.pAsignadas.value +','+vsId;
					}
					else{//Si NO hay plazas asignadas 
						window.opener.document.formPaso1.pAsignadas.value = window.opener.document.formPaso1.pAsignadas.value+vsId;
					}				
				</cfif>	
			}
		}	
		else{//Si es un arreglo de objetos Option button
		
			for (var i = 0; i < document.form1.opt.length; i++) {//Se recorre el objeto en busca de alguno chequeado
				//var vsDesc = document.form1.opt[i].value.substring(document.form1.opt[i].value.indexOf('~')+1,document.form1.opt[i].length)//Codigo y descripcion de la plaza (RHPcodigo,RHPdescripcion)
				//var vsId = document.form1.opt[i].value.substring(0,document.form1.opt[i].value.indexOf('~'))//Id de la plaza (RHPid)
				
				var vsId = linea(document.form1.opt[i].value);
				var vsDesc = descripcion(document.form1.opt[i].value);
		
			
			
				if (document.form1.opt[i].checked) {
		
					window.opener.document.formPaso1.plaza_<cfoutput>#url.id#</cfoutput>.value = vsDesc
					window.opener.document.formPaso1.RHPid_<cfoutput>#url.id#</cfoutput>.value = vsId	
					//var x=	window.opener.document.formPaso1.plaza_<cfoutput>#url.id#</cfoutput>.value
					//alert(x)
					//Actualizar la lista (input) con las  plazas ya asignadas
					
					<cfif isdefined("url.pasignada") and len(trim(url.pasignada))>
					
						var vsplazas = window.opener.document.formPaso1.pAsignadas.value.split(',');
						var vsasignada = <cfoutput>'#url.pasignada#'</cfoutput> //Plaza asignada
						window.opener.document.formPaso1.pAsignadas.value = ''						
						for (i=0; i < vsplazas.length;i++){
							if(vsplazas[i] == vsasignada || vsplazas[i] == vsId){
								if (window.opener.document.formPaso1.pAsignadas.value ==''){
									window.opener.document.formPaso1.pAsignadas.value = vsId
								}
								else{
									window.opener.document.formPaso1.pAsignadas.value = window.opener.document.formPaso1.pAsignadas.value+','+vsId
								}	
							}
							else if (window.opener.document.formPaso1.pAsignadas.value ==''){	
								if (window.opener.document.formPaso1.pAsignadas.value ==''){
									window.opener.document.formPaso1.pAsignadas.value = vsplazas[i]
								}
								else{							
									window.opener.document.formPaso1.pAsignadas.value = window.opener.document.formPaso1.pAsignadas.value+','+vsplazas[i]
								}
							}
							///*-/*/-*/-*/-*/-*/-*/ Si se cierra la ventana automaticamente no hace falta /*/-*/-*/-*/-*/-*
							else {
								if (window.opener.document.formPaso1.pAsignadas.value ==''){
									window.opener.document.formPaso1.pAsignadas.value = vsId
								}
								else{
									window.opener.document.formPaso1.pAsignadas.value = window.opener.document.formPaso1.pAsignadas.value+','+vsplazas[i]
								}	
							}
						}
					<cfelse>					
								
						if(window.opener.document.formPaso1.pAsignadas.value !=''){//Si ya hay plazas asignadas agregar la coma
							window.opener.document.formPaso1.pAsignadas.value=''
							window.opener.document.formPaso1.pAsignadas.value = window.opener.document.formPaso1.pAsignadas.value +vsId;
						}
						else{//Si NO hay plazas asignadas 
							window.opener.document.formPaso1.pAsignadas.value = window.opener.document.formPaso1.pAsignadas.value+vsId;
						}				
					</cfif>	
					break;
				}				
			}			
		}
		window.opener.document.formPaso1.GrabarReasignar.value = 1;
		window.opener.document.formPaso1.IDReasignar.value = <cfoutput>#url.id2#</cfoutput>;
		var vtipo = <cfoutput>'#url.Tipo#'</cfoutput>
		window.opener.document.formPaso1.Tipo.value=vtipo
		window.opener.document.formPaso1.submit();
		window.close();
	}
</script>

<cf_web_portlet_start titulo='#LB_ReasignacionDePlazas#'>	
	<form name="form1" method="get">
		
		
		<table width="95%" cellpadding="0" cellspacing="0" align="center">
			<tr><td align="center" colspan="3" class="tituloAlterno"><strong><cf_translate key="LB_Oferente">Oferente</cf_translate>:&nbsp;<cfoutput>#rsDatos.Nombre#</cfoutput></strong></td></tr>
			<tr><td align="center" colspan="3" class="tituloalterno"><strong><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate>:&nbsp;<cfoutput>#rsDatos.ident#</cfoutput></strong></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td class="titulolistas">&nbsp;</td>
				<td class="titulolistas"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
				<td class="titulolistas"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
			</tr>
			<cfif rsDisponibles.RecordCount NEQ 0>
				<cfoutput query="rsDisponibles">
					<tr class="<cfif rsDisponibles.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td width="3%">
							<input type="radio" name="opt" onclick="javascript: limpialinea(this.value);" value="#rsDisponibles.RHPid#~#rsDisponibles.RHPcodigo#-#rsDisponibles.RHPdescripcion#">						</td>		
						<td width="20%">#rsDisponibles.RHPcodigo#</td>				
						<td width="77%">#rsDisponibles.RHPdescripcion#</td>  <!---#~#--->
					</tr>
				</cfoutput>
			<cfelse>
				<tr><td colspan="3" align="center"><strong>----- <cf_translate key="LB_NoHayPlazasDisponibles">No hay plazas disponibles</cf_translate> -----</strong></td></tr>
			</cfif>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
			  <td colspan="3" align="center">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Asignar"
						Default="Asignar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Asignar"/>				
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Cerrar"
						Default="Cerrar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Cerrar"/>				
				  <cfoutput>
				    <input type="button" name="btnAgregar" value="#BTN_Asignar#" onclick="javascript: funcModificar();" />
				    <input type="button" name="btnCerrar" value="#BTN_Cerrar#" onClick="javascript: window.close();">
				  </cfoutput>				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</form>
<cf_web_portlet_end>	
