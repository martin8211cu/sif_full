<!---Tipo 7-Check de Todos--->
<cfloop list="#url.doc#" delimiters="|" index="i">
	<cfif url.tipo eq 7 and url.value eq 1>
		<cfquery name="rsUp" datasource="#session.dsn#">
			update DAgrupador set Aplica= 1 where DdocumentoId=#i#
		</cfquery>
	</cfif>
	
	<cfif url.tipo eq 7 and url.value eq 0>
		<cfquery name="rsUp" datasource="#session.dsn#">
			update DAgrupador set Aplica= 0 where DdocumentoId=#i#
		</cfquery>
	</cfif>
</cfloop>

<cfquery name="rsCobros1" datasource="#session.dsn#">
			select 
			b.Dsaldo
			 from Documentos b
			where DdocumentoId=#url.doc#
	</cfquery>	

<cfquery name="rsCobros" datasource="#session.dsn#">
	select 
			d.DdocumentoId,
		(select min(SNcodigo) from Documentos where DdocumentoId= d.DdocumentoId) as SNcodigo,
		(select min(s.SNnombre) from SNegocios s,Documentos c where c.DdocumentoId=d.DdocumentoId and s.SNcodigo=c.SNcodigo ) as SNnombre,
		(select min(Mnombre) from Monedas where Mcodigo=d.McodigoOri) as Mnombre,
		(select min(Miso4217) from Monedas where Mcodigo=d.McodigoD) as Miso4217,
		(select min(Ddocumento) from Documentos where DdocumentoId = d.DdocumentoId) as Ddocumento,
		d.CCTcodigo,
		d.McodigoD,
		d.McodigoOri,
		d.DAmontoD,
		d.DAretencion,
		d.Aplica,
		DAmontoC		
	from DAgrupador d
	where EAid= #url.EAid#	
	and DdocumentoId= #doc#
</cfquery>

<!---Tipo 1-Check de Aplica--->
<cfif url.tipo eq 1 and url.value eq 1>
	<cfquery name="rsUp" datasource="#session.dsn#">
		update DAgrupador set Aplica= 1 where DdocumentoId=#url.doc#
	</cfquery>
</cfif>

<cfif url.tipo eq 1 and url.value eq 0>
	<cfquery name="rsUp" datasource="#session.dsn#">
		update DAgrupador set Aplica= 0 where DdocumentoId=#url.doc#
	</cfquery>
</cfif>

<!---Tipo 2-Cambio de moneda--->

<cfif url.tipo eq 2>
	<cfif url.value eq 1>
		<cfquery name="rsUp" datasource="#session.dsn#">
			update DAgrupador set McodigoD= #url.moneda# , DAmontoD= #rsCobros1.Dsaldo#, DAmontoC=#rsCobros1.Dsaldo#, DAretencion= 0.00 where DdocumentoId=#url.doc#
		</cfquery>
		<cfoutput>
			<script language="javascript1.2" type="text/javascript">
				window.parent.document.getElementById("Mretencion_" + #url.doc#).value = "0.00";	
				window.parent.document.getElementById("MontoC_" + #url.doc#).value = "#NumberFormat(rsCobros1.Dsaldo,'0.00')#";				 
				window.parent.document.getElementById("MontoM_" + #url.doc#).value = "#NumberFormat(rsCobros1.Dsaldo,'0.00')#";				 
			</script>
		</cfoutput>
	<cfelse>
		<cfquery name="rsUp" datasource="#session.dsn#">
			update DAgrupador set McodigoD= #url.moneda# where DdocumentoId=#url.doc#
		</cfquery>
	</cfif>
</cfif>


<!---Tipo 3-Cambio del monto del documento--->
<cfif url.tipo eq 3>
	<cfif url.monto gt #rsCobros1.Dsaldo#>
		<cfoutput>
			<script language="javascript1.2" type="text/javascript">
				alert ('El monto digitado supera el saldo del documento,debe ser inferio o igual a '+ #rsCobros1.Dsaldo#);
				window.parent.document.getElementById("MontoM_" + #url.doc#).value = "#NumberFormat(rsCobros1.Dsaldo,'0.00')#";	
			</script>
		</cfoutput>
	<cfelse>
		<cfquery name="rsUp" datasource="#session.dsn#">
				update DAgrupador set DAmontoD= #url.monto# where DdocumentoId=#url.doc# and EAid=#url.EAid#
		</cfquery>
	</cfif>
</cfif>


<!---Tipo 4-Cambio de retencion--->
<cfif url.tipo eq 4>
	<cfif (#url.monto#+#rsCobros.DAmontoD#) gt #rsCobros1.Dsaldo# >
		<cfoutput>
			<script language="javascript1.2" type="text/javascript">
				alert ('El monto del documento + retenciones supera el saldo del documento, debe ser inferior o igual a '+ #rsCobros1.Dsaldo#);
				window.parent.document.getElementById("Mretencion_" + #url.doc#).value = "0.00";
			</script>
		</cfoutput>
	<cfelse>
	<cfquery name="rsUp" datasource="#session.dsn#">
			update DAgrupador set DAretencion= #url.monto# where DdocumentoId=#url.doc# and EAid=#url.EAid#
	</cfquery>
	</cfif>
</cfif>


<!---Tipo 5-Cambio en monto de moneda de cobro--->
<cfif url.tipo eq 5>
	<cfif url.monto gt #rsCobros1.Dsaldo#>
		<cfoutput>
			<script language="javascript1.2" type="text/javascript">
				alert ('El monto digitado supera el saldo del documento,debe ser inferio o igual a '+ #rsCobros1.Dsaldo#);
				window.parent.document.getElementById("MontoC_" + #url.doc#).value = "#NumberFormat(rsCobros1.Dsaldo,'0.00')#";	
			</script>
		</cfoutput>
	<cfelse>
	<cfquery name="rsUp" datasource="#session.dsn#">
			update DAgrupador set DAmontoC= #url.monto# where DdocumentoId=#url.doc# and EAid=#url.EAid#
	</cfquery>
	</cfif>
	</cfif>


