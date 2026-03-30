<cfparam name="url.CMPid" default="-1">
<cfparam name="form.TGtipoF" default="2">
<form action="" method="post" name="form1">
	<table width="100%" border="0" align="center">
	<tr><td colspan="2">&nbsp;</td></tr>
		<tr>			
			<td> 			
				<strong>Tipo Garantía: </strong>				
				 <select name="TGtipoF" tabindex="1" id="TGtipoF" onChange="javascript: Cambio(this);">
					<option value="1" <cfif form.TGtipoF eq '1'><cfoutput>selected="selected"</cfoutput></cfif>>Participación</option>
					<option value="2" <cfif form.TGtipoF eq '2'><cfoutput>selected="selected"</cfoutput></cfif>>Cumplimiento</option>
				 </select>
			</td>
		</tr>
	</table>

<cfset lvarTipo = #form.TGtipoF#>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
	<cfquery name="rsSolicitudesTodo" datasource="#Session.DSN#">
		select 
		tg.TGtipo,
		e.DSlinea,
		e.DSdescripcion,
		<cf_dbfunction name="to_char" args="cc.CMPid"> #_Cat# '|' #_Cat# 
		<cf_dbfunction name="to_char" args="a.ESidsolicitud"> #_Cat# '|' #_Cat# 
		<cf_dbfunction name="to_char" args="e.DSlinea"> 
		as idGroup,
		
		(
			select <cf_dbfunction name="to_char" args="prs.CMPid_CM"> 
			#_Cat# '|' #_Cat#  <cf_dbfunction name="to_char" args="pdr.ESidsolicitud"> 
			#_Cat# '|' #_Cat#  <cf_dbfunction name="to_char" args="pdr.DSlinea">
			#_Cat# '|' #_Cat#	 <cf_dbfunction name="to_char" args="tg.TGtipo">
			
			from CMProceso prs 
			inner join CMDProceso pdr 
				on pdr.CMPid = prs.CMPid
			where 
			pdr.CMPid = #url.CMPid# 
			and prs.CMPid_CM = cc.CMPid
			and pdr.ESidsolicitud = e.ESidsolicitud  
			and pdr.DSlinea = e.DSlinea 
		) as idGroup2,
		
		cc.CMPid, 
		cc.CMPnumero,
		'N° Proceso' #_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="cc.CMPnumero"> #_Cat# ' - ' #_Cat#  cc.CMPcodigoProceso #_Cat# ' - ' #_Cat# rtrim(ltrim(cc.CMPdescripcion))  as CMPdescripcion,
		rtrim(ltrim(b.CMTSdescripcion)) #_Cat# ' - ' #_Cat# rtrim(ltrim(a.ESobservacion)) as CMTSdescripcion,
		e.DScant - e.DScantsurt as Cantidad,
		a.ESobservacion,
		a.ESestado, c.CFcodigo,
		a.ESidsolicitud,
		a.ESnumero,
		a.ESobservacion,
		a.ESfecha, 
		c.CFid, 
		c.CFdescripcion,
        cc.CMPcodigoProceso, 
	<!--- ((select min(d.CMSnombre) from CMSolicitantes d where d.CMSid = a.CMSid)) as CMSnombre,
		e.DSlinea, e.DSdescripcion, e.DScant, e.DScantsurt, f.Udescripcion, ((select min(cfd.CFcodigo) 
		from CFuncional cfd where cfd.CFid = e.CFid)) as CFcodigoDet, 
		((select min(cfd.CFdescripcion) from CFuncional cfd where cfd.CFid = e.CFid)) as CFdescripcionDet, 
	--->		
		case e.DStipo when 'A' then (select min(Acodigo) 
		from Articulos x where x.Ecodigo = e.Ecodigo and x.Aid = e.Aid) 
		when 'S' then (select min(Ccodigo) from Conceptos x where x.Ecodigo = e.Ecodigo and x.Cid = e.Cid) else '' end as CodigoItem 
		
		from ESolicitudCompraCM a
		 inner join CMTiposSolicitud b 
			on b.Ecodigo = a.Ecodigo 
			and b.CMTScodigo = a.CMTScodigo
		 inner join CFuncional c 
			on c.CFid = a.CFid 
			
		inner join DSolicitudCompraCM e 
			on e.ESidsolicitud = a.ESidsolicitud
		inner join CMLineasProceso  pr
			on pr.DSlinea = e.DSlinea
		inner join CMProcesoCompra  cc
			on cc.CMPid = pr.CMPid
			
		<cfif isdefined('lvarTipo') and #lvarTipo# eq 2>
			inner join TiposGarantia tg
				on tg.TGid = cc.TGidC
		<cfelse>
			inner join TiposGarantia tg
				on tg.TGid = cc.TGidP
		</cfif>
			
		inner join Unidades f 
			on f.Ecodigo = e.Ecodigo 
			and f.Ucodigo = e.Ucodigo 
		where  cc.CMPestado in (10, 50) 		
		and a.Ecodigo = #session.Ecodigo#
		and tg.TGtipo = #lvarTipo# 
		<cfif isdefined('form.filtro_DSdescripcion') and len(trim(form.filtro_DSdescripcion))>
			and upper(cc.CMPdescripcion) like upper('%#form.filtro_DSdescripcion#%')
		</cfif>
        <cfif isdefined('form.filtro_CMPcodigoProceso') and len(trim(form.filtro_CMPcodigoProceso))>
			and upper(cc.CMPcodigoProceso) like upper('%#form.filtro_CMPcodigoProceso#%')
		</cfif>
		<cfif isdefined('form.filtro_CodigoItem') and len(trim(form.filtro_CodigoItem))>

			and (<cf_dbfunction name="to_char" args="cc.CMPnumero">) like upper('%#form.filtro_CodigoItem#%')
		</cfif>
		order by cc.CMPid,a.ESidsolicitud,e.DSlinea
	</cfquery>

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
		<cfinvokeargument name="query" 				 	value="#rsSolicitudesTodo#"/>
		<cfinvokeargument name="desplegar"  		 	value="CodigoItem,CMPcodigoProceso,DSdescripcion"/>	<!---,Cantidad,Udescripcion,CFdescripcionDet--->
		<cfinvokeargument name="etiquetas"     			value="N° Proceso,Codigo Proceso,Descripción"><!---,Cantidad,Unidad,Centro Funcional--->
		<cfinvokeargument name="formatos"   		 	value="S,S,S,"/><!---S,S,S--->
		<cfinvokeargument name="align" 				 	value="left,left,left"/><!---,left,left,left--->
		<cfinvokeargument name="irA"           			value=""/>
		<cfinvokeargument name="keys"          			value="CMPid,ESidsolicitud,DSlinea,TGtipo"/>
		<cfinvokeargument name="checkedcol" 			value="idGroup2"/><!---,checked2,checked3--->
		<cfinvokeargument name="cortes"   				value="CMPdescripcion,CMTSdescripcion"/>
		<cfinvokeargument name="checkboxes"   			value="S"/>
		<cfinvokeargument name="chkcortes"   			value="S"/>
		<cfinvokeargument name="incluyeForm"   			value="false"/>
		<cfinvokeargument name="keycorte"   		 	value="CMPid,idGroup"/>
		<cfinvokeargument name="fparams"   			 	value="CMPnumero"/>
		<cfinvokeargument name="checkbox_function" 		value="Procesar(this)"/>
		<cfinvokeargument name="botones" 				value="Aceptar"/>
		<cfinvokeargument name="mostrar_filtro" 		value="true"/>
		<cfinvokeargument name="filtrar_automatico"  	value="true"/>
		<cfinvokeargument name="formName" 				value="form1"/> 
		<cfinvokeargument name="checkall" 				value="N"/> 
	</cfinvoke>

<script language="javascript">

	function funcFiltroChkAllform1(c){ 
		if (c.checked) {
			allChecked = false;
			}

	}
	
	function funcChkPadre(c) { 
		  ArraySelected = c.value.split( "|" );///[0] Proceso [1] Solicitud
		if (ArraySelected.length == 1)
			father = 'P'; //Proceso de Compra
		else
			father = 'S'; //Solicitud de Compra
			
		
		//Chekear las lineas de la Solicitud
		for (var counter = 0; counter < document.form1.chk.length; counter++) { 
		if (!document.form1.chk[counter].disabled)
			{
				ArrayItem   = document.form1.chk[counter].value.split( "|" ); //[0] Proceso [1] Solicitud [2] Lineas de la Solicitud
			
				//--------------
				
				if (father == 'P' && ArraySelected[0] == ArrayItem[0])				
					document.form1.chk[counter].checked = c.checked;
					
				//marca las hijos
				else if (father == 'S' && ArraySelected[0] == ArrayItem[0] && ArraySelected[1] == ArrayItem[1])
					document.form1.chk[counter].checked = c.checked;
				
				//desmarcar	
				else if (father == 'P' && ArraySelected[0] != ArrayItem[0])	
				document.form1.chk[counter].checked = 0; 		
				
				 if (father == 'S' && ArraySelected[0] != ArrayItem[0] && ArraySelected[1] != ArrayItem[1])
				document.form1.chk[counter].checked = 0;
			}
		}
		///chekear las Solicitudes del Proceso
		for (var counter = 0; counter < document.form1.chkPadre.length; counter++) { 
			Arrayfather = document.form1.chkPadre[counter].value.split( "|" ); //[0] Proceso [1] Solicitud [2] Lineas de la Solicitud
			
			//marca las solicitudes

		if (father == 'P' && ArraySelected[0] == Arrayfather[0])
			document.form1.chkPadre[counter].checked = c.checked;
					
			//desmarcar	
		else if (ArraySelected[0] != Arrayfather[0] && ArraySelected[1] != ArrayItem[1])
			document.form1.chkPadre[counter].checked = 0;
		}
	}
	
	
	function Procesar(c){
	
	 ArraySelected = c.value.split( "|" );///[0] Proceso [1] Solicitud
		if (ArraySelected.length == 1)
			father = 'P'; //Proceso de Compra
		else
			father = 'S'; //Solicitud de Compra
	
		for (var counter = 0; counter < document.form1.chk.length; counter++) { 
		if (!document.form1.chk[counter].disabled)
			{
				ArrayItem   = document.form1.chk[counter].value.split( "|" ); //[0] Proceso [1] Solicitud [2] Lineas de la Solicitud
				//desmarcar	
				 if (father == 'P' && ArraySelected[0] != ArrayItem[0])	
				document.form1.chk[counter].checked = 0; 		
				
				 if (father == 'S' && ArraySelected[0] != ArrayItem[0] && ArraySelected[1] != ArrayItem[1])
				document.form1.chk[counter].checked = 0;
			}
		}
		
		for (var counter = 0; counter < document.form1.chkPadre.length; counter++) { 
			Arrayfather = document.form1.chkPadre[counter].value.split( "|" ); //[0] Proceso [1] Solicitud [2] Lineas de la Solicitud
			
			//marca las solicitudes

		if (father == 'P' && ArraySelected[0] == Arrayfather[0])
			document.form1.chkPadre[counter].checked = c.checked;
					
			//desmarcar	
		else if (ArraySelected[0] != Arrayfather[0] && ArraySelected[1] != ArrayItem[1])
			document.form1.chkPadre[counter].checked = 0;
		}
	}
	
	
	function funcAceptar(){ 
	window.opener.document.form1.COEGTipoGarantia.value = document.form1.TGtipoF.value;

			document.form1.action="../../conavi/garantia/operacion/GarantiaSql.cfm";
			<cfif isdefined('url.funcionT') and len(trim(url.funcionT))>
				var input = document.createElement("input");
				input.name = "funcionT";
				input.value = "<cfoutput>#url.funcionT#</cfoutput>";
				input.type = "hidden";
				document.form1.appendChild(input); 
			</cfif>
			<cfif isdefined('url.columnas') and len(trim(url.columnas))>
				var input = document.createElement("input");
				input.name = "columnas";
				input.value = "<cfoutput>#url.columnas#</cfoutput>";
				input.type = "hidden";
				document.form1.appendChild(input); 
			</cfif>
			return algunoMarcado();
		}
</script>


<script language="javascript" type="text/javascript">
	function Cambio(a) {
		if(a.value == 1){
			document.form1.TGtipoF.value = 1;
		}else{
			document.form1.TGtipoF.value = 2;		
		}document.form1.submit();
	}	


	//funcion para verificar si hay alguna transaccion marcada devuelve un booleano
	function algunoMarcado(){
		var aplica = false;
		if (document.form1.chk) {
			if (document.form1.chk.value) {
				aplica = document.form1.chk.checked;
			} else {
				for (var i=0; i<document.form1.chk.length; i++) {
					if (document.form1.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (!aplica) {
			alert('Debe seleccionar al menos un registro');
			return false;
		}
		
	}
</script>
</form>
