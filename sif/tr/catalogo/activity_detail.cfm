<cfparam name="session.ProcessId" type="numeric">
<cfparam name="url.ActivityId" type="string" default="xxx">

<cfif Not REFind('[0-9]+', url.ActivityId)>
	Parametro Invalido
	<cfabort>
</cfif>

<cfquery datasource="#session.dsn#" name="WfProcess">
	select PublicationStatus
	from WfProcess
	where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
</cfquery>

<!---
	Generalmente la Actividad 1 (Inicio del Trámite) está definida como sólo lectura, por tanto,
	no puede tener Responsables. La Actividad 2 es en realidad la primera Actividad del Trámite.
	Existe la posibilidad de que la Actividad 1 tenga Responsables, de modo que la Actividad 2
	va a tener como Actividad inmediata anterior la actividad 1.
--->
<cfquery datasource="#session.dsn#" name="rsFirst">
	select count(1) as Parts
	  from WfTransition t
		inner join WfActivity a
			 on a.ProcessId  = t.ProcessId
			and a.ActivityId = t.FromActivity
			and a.IsStart	 = 1
		inner join WfActivityParticipant ap
			 on ap.ActivityId = a.ActivityId
	 where t.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
</cfquery>

<cfquery datasource="#session.dsn#" name="Activity">
	select aa.*,
		<cfif rsFirst.Parts EQ 0>
			(
				select min(<cf_dbfunction name="to_char" args="a.IsStart" isnumber="no">)
				  from WfTransition t
					inner join WfActivity a
						 on a.ProcessId = t.ProcessId
						and a.ActivityId = t.FromActivity
				 where t.ProcessId = aa.ProcessId
				   and t.ToActivity = aa.ActivityId
			)
		<cfelse>
			IsStart
		</cfif>
		as FromStart
	from WfActivity aa
	where ProcessId		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
	  and ActivityId	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityId#">
	order by Ordering
</cfquery>

<cfquery datasource="#session.dsn#" name="ActivityInvocation">
	select i.ApplicationName
	from WfInvocation i
	where i.ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityId#">
</cfquery>

<cfquery name="rsParticipantes" datasource="#Session.DSN#">
	select pa.Name, pa.Description, pa.Usucodigo, ap.ParticipantId, pa.ParticipantType
	from WfParticipant pa,
		WfActivityParticipant ap,
		WfProcess p
	where pa.PackageId = p.PackageId
	  and p.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ProcessId#">
		and ap.ActivityId= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ActivityId#">
		and pa.ParticipantId=ap.ParticipantId
	order by ParticipantType, pa.Name

</cfquery>
<html>
<head>
<cf_templatecss>
<cf_templatecss>

<style type="text/css">
td.listaParticipantes  {
	border-right:1px solid #c0c0c0;
}
</style>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaQuitarAlResponsable"
	Default="Desea quitar al responsable"
	returnvariable="MSG_DeseaQuitarAlResponsable"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElNombreEsRequerido"
	Default="El nombre es requerido"
	returnvariable="MSG_ElNombreEsRequerido"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_LaDescripcionEsRequerida"
	Default="La descripción es requerida"
	returnvariable="MSG_LaDescripcionEsRequerida"/>

<script type="text/javascript">
<!--
<cfparam name="url.reloadflash" default="0">
<cfif url.reloadflash is '1'>
if (document.all) {
	window.parent.document.diagrama.rewind();
} else {
	<cfoutput>
	window.parent.document.location.href='process.cfm?ProcessId=#session.ProcessId#&ActivityId=#url.ActivityId#';
	</cfoutput>
}
</cfif>

	if (window.top == window) {
		top.location.href = 'process.cfm?<cfoutput>ProcessId=#URLEncodedFormat(session.ProcessId)#&ActivityId=#URLEncodedFormat(url.ActivityId)#</cfoutput>';
	}

	function closePopup() {
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
			window.gPopupWindow = null;
		}
	}
	function conlisUsuarios(){
		if (window.gPopupWindow != null && !window.gPopupWindow.closed ) {
			window.gPopupWindow.close();
		}
		window.gPopupWindow = window.open("conlis_part_all.cfm?s=RH&activityid=<cfoutput>#URLEncodedFormat(url.ActivityId)#</cfoutput>","conlis",
			"width=640,height=480,left=100,top=100,toolbar=no");
		window.onfocus = closePopup;
	}

	function NuevoParticipante(Type, Name, Description, rol, Usucodigo, CFid, ParticipantId) {
		document.form1.PartType.value        = Type;
		document.form1.PartName.value        = Name;
		document.form1.PartDescription.value = Description;
		document.form1.Part_rol.value        = rol;
		document.form1.Part_Usucodigo.value  = Usucodigo;
		document.form1.Part_CFid.value       = CFid;
		document.form1.Part_PartId.value     = ParticipantId;
		document.form1.submit();
	}
	//window.NuevoParticipante = NuevoParticipante;

	function QuitarResponsable (ParticipantId,Nombre){
		var cf = confirm('¿<cfoutput>#MSG_DeseaQuitarAlResponsable#</cfoutput> ' + Nombre + '?');
		if (cf) {
			document.form1.ParticABorrar.value = ParticipantId;
			document.form1.submit();
		}
	}


	function validarForm(f) {
		if (f.Name.value.match(/^\s*$/)) {
			alert("<cfoutput>#MSG_ElNombreEsRequerido#</cfoutput>");
			f.Name.focus();
			return false;
		}if (f.Description.value.match(/^\s*$/)) {
			alert("<cfoutput>#MSG_LaDescripcionEsRequerida#</cfoutput>");
			f.Description.focus();
			return false;
		}
		return true;
	}


function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

//-->
</script>

</head><body onLoad="MM_preloadImages('agregar_responsable_on.gif')">

<cfoutput>
  <form action="activity_apply.cfm" method="post" name="form1" id="form1" onSubmit="return validarForm(this);">
<input name="ActivityId" type="hidden" id="ActivityId" value="#HTMLEditFormat(url.ActivityId)#">
<table width="950" border="0" cellpadding="1" cellspacing="0">
  <!--DWLayoutTable-->
	  <tr>
	    <td width="230" class="subTitulo"><cf_translate key="LB_NombreDeLaActividad">Nombre de la <strong>Actividad</strong></cf_translate></td>
	    <td width="301" class="subTitulo"><strong><cf_translate key="LB_DocumentacionDetallada">Documentaci&oacute;n detallada</cf_translate></strong></td>
        <td width="418" class="subTitulo"><strong><cf_translate key="LB_ResponsableDeCompletarEstaActividad">Responsable<cfif rsParticipantes.RecordCount neq 1>s</cfif> de completar esta actividad</cf_translate></strong></td>
	  </tr>
    <tr>
      <td valign="top">
	    <table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td valign="top" colspan="2">
				<input name="Name" type="text" id="Name" onFocus="this.select()" size="40" maxlength="20" value="#HTMLEditFormat(Activity.Name)#">
			</td>
          </tr>
          <tr>
            <td valign="top" colspan="2">
				<strong><cf_translate key="LB_Descripcion" XmlFile="/sif/generales.xml">Descripci&oacute;n</cf_translate></strong>
			</td>
          </tr>
          <tr>
            <td valign="top" colspan="2">
				<input name="Description" type="text" id="Description" onFocus="this.select()" size="40" maxlength="255" value="#HTMLEditFormat(Activity.Description)#">
			</td>
          </tr>
          <tr><td valign="top">&nbsp;</td></tr>
          <tr>
            <td valign="top" colspan="2" nowrap="nowrap">
				<strong><cf_translate key="LB_Notificacion">Notificar por eMail el Status del Trámite:</cf_translate></strong>
			</td>
          </tr>
          <tr>
			<td valign="top" nowrap>
				<input name="ckNotifyPartAfter" type="checkbox" id="ckNotifyPartAfter" value="checkbox" <cfif Activity.NotifyPartAfter is 1> checked </cfif>>
			</td>
			<td valign="top" nowrap>
				<label for="ckNotifyPartAfter"><cf_translate key="CHK_NotificarAResponsablesPorEmail">A responsables de la Actividad</cf_translate></label>
			</td>
          </tr>
          <tr>
            <td valign="top" nowrap>
				<input name="ckNotifyReqAfter" type="checkbox" id="ckNotifyReqAfter" value="checkbox" <cfif Activity.NotifyReqAfter is 1> checked </cfif>>
			</td>
            <td valign="top" nowrap>
				<label for="ckNotifyReqAfter"><cf_translate key="CHK_NotificarAlSolicitantePorEmail">Al solicitante del Trámite</cf_translate></label>
			</td>
          </tr>
          <tr>
            <td valign="top" nowrap>
				<input name="ckNotifySubjAfter" type="checkbox" id="ckNotifySubjAfter" value="checkbox" <cfif Activity.NotifySubjAfter is 1> checked </cfif>>
			</td>
            <td valign="top" nowrap>
				<label for="ckNotifySubjAfter"><cf_translate key="CHK_NotificarAlInteresadoPorEmail">Al interesado del Trámite</cf_translate></label>
			</td>
          </tr>
          <tr>
            <td valign="top">
				<input name="ckNotifyAllAfter" type="checkbox" id="ckNotifyAllAfter" value="checkbox" <cfif Activity.NotifyAllAfter is 1> checked </cfif>>
			</td>
            <td valign="top">
				<label for="ckNotifyAllAfter"><cf_translate key="CHK_NotificarATodosPorEmail">A todos los participantes involucrados en el Trámite</cf_translate></label>
			</td>
          </tr>
          <tr><td valign="top">&nbsp;</td></tr>
      </table></td>
		<td valign="top">
	  		<textarea name="Documentation" cols="60" rows="7" id="Documentation" style="font-family:Arial, Helvetica, sans-serif;width:300px">#HTMLEditFormat(Activity.Documentation)#</textarea>
		</td>
      	<td valign="top" rowspan="3">

			<div style="width:98%;height:100px;overflow:auto;border:2px inset;">
			<table border="0" cellpadding="2" cellspacing="0" width="100%">
			<cfloop query="rsParticipantes">
			<tr height="18" valign="top" style="text-indent:0;background-color:<cfif CurrentRow mod 2>##ffffff<cfelse>##fafafa</cfif>">
				<td class="listaParticipantes">#CurrentRow#</td>
				<td class="listaParticipantes" align="center">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_QuitarA"
					Default="Quitar a"
					returnvariable="MSG_QuitarA"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_DeEstaAct"
						Default="de esta actividad"
						returnvariable="MSG_DeEstaAct"/>

					<a href="javascript: QuitarResponsable(#rsParticipantes.ParticipantId#,'#JSStringFormat(rsParticipantes.Description)#');">
					<img width="12" height="11" alt="#MSG_QuitarA# #HTMLEditFormat(rsParticipantes.Description)# #MSG_DeEstaAct#"  src="borrar.gif" border="0"></a>
				</td>
				<cfset PartType = ListGetAt(rsParticipantes.ParticipantType &
					',USUARIO,C. FUNCIONAL,GRUPO,ROL,Jefe del paso anterior',
					1+ListFindNoCase('HUMAN,ORGUNIT,GROUP,ROLE,BOSS',rsParticipantes.ParticipantType))>
				<cfif rsParticipantes.ParticipantType is 'BOSS'>
					<td class="listaParticipantes" nowrap>JEFE</td>
					<td align="left" colspan="2" >
					<cfif Activity.FromStart EQ "1">
						<cf_translate key="LB_JefeInmediatoDeQuienIniciaElTramite">Jefe Inmediato de quien inicia el tr&aacute;mite</cf_translate>
					<cfelse>
						<cf_translate key="LB_JefeInmediatoDelResponsablePasoAnterior">Jefe Inmediato del responsable del paso anterior</cf_translate>
					</cfif>
					</td>
				<cfelseif rsParticipantes.ParticipantType is 'BOSSAP1'>
					<td class="listaParticipantes" nowrap>APROBADOR ORI</td>
					<td align="left" colspan="2" >
					<cf_translate key="LB_AUTORZDST">Aprobador del Centro Funcional Origen</cf_translate>
					</td>
				<cfelseif rsParticipantes.ParticipantType is 'BOSSAP2'>
					<td class="listaParticipantes" nowrap>APROBADOR DST</td>
					<td align="left" colspan="2" >
					<cf_translate key="LB_AUTORZDST">Aprobador del Centro Funcional Destino</cf_translate>
					</td>
				<cfelseif rsParticipantes.ParticipantType is 'BOSS1'>
					<td class="listaParticipantes" nowrap>JEFE ORI</td>
					<td align="left" colspan="2" >
					<cf_translate key="LB_JefeCFdestino">Jefe del Centro Funcional Origen</cf_translate>
					</td>
				<cfelseif rsParticipantes.ParticipantType is 'BOSS2'>
					<td class="listaParticipantes" nowrap>JEFE DST</td>
					<td align="left" colspan="2" >
					<cf_translate key="LB_JefeCFdestino">Jefe del Centro Funcional Destino</cf_translate>
					</td>
				<cfelseif rsParticipantes.ParticipantType is 'BOSSES1'>
					<td class="listaParticipantes" nowrap>AUTORZA ORI</td>
					<td align="left" colspan="2" >
					<cf_translate key="LB_AUTORZORI">Rol Autorizador Oficina Origen</cf_translate>
					</td>
				<cfelseif rsParticipantes.ParticipantType is 'BOSSES2'>
					<td class="listaParticipantes" nowrap>AUTORZA DST</td>
					<td align="left" colspan="2" >
					<cf_translate key="LB_AUTORZDST">Rol Autorizador Oficina Destino</cf_translate>
					</td>
				<cfelse>
					<td class="listaParticipantes" nowrap>#PartType#</td>
					<td class="listaParticipantes" align="center" nowrap>#rsParticipantes.Name#</td>
					<td>#rsParticipantes.Description#</td>
				</cfif>
				</tr>
			</cfloop>

			<cfif rsParticipantes.RecordCount is 0>
			<tr><td colspan="5"><cf_translate key="MSG_NoHayResponsablesDefinidos">No hay responsables definidos</cf_translate></td></tr>
			<cfelse>
			<tr height="18" valign="top" style="text-indent:0;background-color:##ffffff">
				<td class="listaParticipantes">&nbsp;</td>
				<td class="listaParticipantes" align="center">&nbsp;</td>
				<td class="listaParticipantes" nowrap>&nbsp;</td>
				<td class="listaParticipantes" align="center" nowrap>&nbsp;</td>
				<td>&nbsp;</td></tr>
			</cfif>
	    </table></div>
			<cfif not Activity.ReadOnly>
			<div>
				<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="ALT_AgregaResponsable"
						Default="Agregar Responsable"
						returnvariable="ALT_AgregaResponsable"/>
					<a href="javascript:conlisUsuarios()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Agregar_Responsable','','agregar_responsable_on.gif',1)">
					<img src="agregar_responsable_off.gif" alt="#ALT_AgregaResponsable#" name="Agregar_Responsable" width="200" height="18" border="0"></a>
					<input type="hidden" readonly="" id="ParticABorrar" name="ParticABorrar" value="" >
					<input type="hidden" readonly="" id="PartType" name="PartType" value="" >
					<input type="hidden" readonly="" id="Part_rol" name="Part_rol" value="" >
					<input type="hidden" readonly="" id="Part_Usucodigo" name="Part_Usucodigo" value="" >
					<input type="hidden" readonly="" id="Part_CFid" name="Part_CFid" value="" >
					<input type="hidden" readonly="" id="Part_PartId" name="Part_PartId" value="" >
			    <input type="hidden" readonly="" id="PartName" name="PartName" value="" >
				 <input type="hidden" readonly="" id="PartDescription" name="PartDescription" value="" >
			 </div>
			</cfif>

	  </td>
    </tr>
           <tr>
            <td  valign="top" colspan="2">
				<cfif not Activity.ReadOnly and ListFind('RELEASED,RETIRED', WfProcess.PublicationStatus) is 0>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Aplicar"
						Default="Aplicar"
						XmlFile="/sif/generales.xml"
						returnvariable="BTN_Aplicar"/>

					<input type="submit" name="apply" value="#BTN_Aplicar#">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Eliminar"
						Default="Eliminar"
						XmlFile="/sif/generales.xml"
						returnvariable="BTN_Eliminar"/>

					<input type="submit" name="delete" value="#BTN_Eliminar#" onClick="form.onSubmit=''; window.status='xx'">
	  			</cfif>
                <cfif Activity.IsFinish>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Mails"
						Default="Registrar Notificaciones"
						XmlFile="/sif/generales.xml"
						returnvariable="BTN_Mails"/>

					<input type="submit" name="btnMails" value="#BTN_Mails#">
                </cfif>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_Cancelar"
					Default="Cancelar"
					XmlFile="/sif/generales.xml"
					returnvariable="BTN_Cancelar"/>

				<input type="button" name="cancelar" value="&lt;&lt; #BTN_Cancelar#" onClick="location.href='process_detail.cfm'">
			</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td valign="top" colspan="2">
				<cfif Activity.IsStart or Activity.IsFinish or Activity.ReadOnly>
                <strong><cf_translate key="LB_CaracteristicasEspeciales">Caracter&iacute;sticas especiales</cf_translate>: </strong>
            	</cfif>
			</td>
          </tr>
          <tr>
            <td valign="top" colspan="3">
			<cfif Activity.IsStart or Activity.IsFinish or Activity.ReadOnly><ul>
			<cfif Activity.IsStart>
       				 <li><cf_translate key="LB_TareaDeInicio">Tarea de inicio</cf_translate></li>
              </cfif>
                <cfif Activity.IsFinish>
                	  <li><cf_translate key="LB_TareaDeFinal">Tarea de final</cf_translate></li>
                </cfif>
                <cfif Activity.ReadOnly>
       				 <li><cf_translate key="LB_NoModificable">No modificable</cf_translate></li>
                </cfif>
                <cfif ActivityInvocation.RecordCount>
       				 <li><cf_translate key="LB_InvocaUnProcesoInterno">Invoca un proceso interno</cf_translate>: #ValueList(ActivityInvocation.ApplicationName)#</li>
                </cfif>
				</ul>
				</cfif>
            </td>
          </tr>
 </table>
</form></cfoutput>
</body></html>