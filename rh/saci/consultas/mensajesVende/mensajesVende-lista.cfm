<!---<cfset filtro = " mc.MSrevAgente <> 'L' ">--->
<cfset filtro = "1=1">

<cfset camposExtra = "">
<cfoutput>
	<cfif isdefined('url.AGIDP') and url.AGIDP NEQ ''>
		<cfset filtro = filtro & " and mc.AGid = #url.AGIDP#">
		<cfset camposExtra = camposExtra & ",#url.AGIDP# as AGIDP_f">
	</cfif>	
	<cfif isdefined('url.Pquien') and url.Pquien NEQ ''>
		<cfset camposExtra = camposExtra & ",#url.Pquien# as Pquien_f">
	</cfif>		
	<cfif isdefined('url.LGlogin') and url.LGlogin NEQ ''>
		<cfset filtro = filtro & " and upper(lo.LGlogin) like upper('%#url.LGlogin#%')">
		<cfset camposExtra = camposExtra & ",'#url.LGlogin#' as LGlogin_f">
	</cfif>		
	<cfif isdefined('url.fechaIni') and url.fechaIni NEQ ''>
		<cfset filtro = filtro & " and mc.MSfechaCompleto >= '" & LSDateFormat(url.fechaIni, "yyyymmdd") & "'">
		<cfset camposExtra = camposExtra & ",'#url.fechaIni#' as fechaIni_f">
	</cfif>		
	<cfif isdefined('url.fechaFin') and url.fechaFin NEQ ''>
		<cfset filtro = filtro & " and mc.MSfechaCompleto <= '" & LSDateFormat(url.fechaFin, "yyyymmdd") & "'">
		<cfset camposExtra = camposExtra & ",'#url.fechaFin#' as fechaFin_f">
	</cfif>	
	<cfif isdefined('url.MSoperacion') and url.MSoperacion NEQ '-1'>
		<cfset filtro = filtro & " and mc.MSoperacion = '#url.MSoperacion#'">
		<cfset camposExtra = camposExtra & ",'#url.MSoperacion#' as MSoperacion_f">
	</cfif>	
	<cfif isdefined('url.MSrevAgente') and url.MSrevAgente NEQ '-1'>
		<cfset filtro = filtro & " and mc.MSrevAgente = '#url.MSrevAgente#'">
		<cfset camposExtra = camposExtra & ",'#url.MSrevAgente#' as MSrevAgente_f">
	</cfif>	

</cfoutput>


<cfinvoke 
	component="sif.Componentes.pListas"
	method="pListaRH"
	returnvariable="pListaRet"
		columnas="
				mc.MSid
				#camposExtra#
				, mc.AGid
				, (perAG.Pnombre || ' ' || perAG.Papellido || ' ' || perAG.Papellido2) as nombreAG
				, lo.LGlogin
				, c.CUECUE
				, p.CNnumero
				, case mc.MSoperacion
					when 'L' then 'Bloquear'
					when 'D' then 'Desbloquear'
					when 'B' then 'Borrar'
					when 'P' then 'Programar (activar)'
					when 'O' then 'Moroso'
					when 'I' then 'Informativo'
				  end MSoperacion
				, mc.MSfechaCompleto
				, mot.MBdescripcion	
				, mc.MSsaldo
				, lo.LGserids
				, p.CNsuscriptor
				, p.PQcodigo
				, (per.Pnombre || ' ' || per.Papellido || ' ' || per.Papellido2 || ' ' || per.PrazonSocial) as nombreCuenta
				, MSrevAgente as revisadoagente"
		tabla="
				ISBmensajesCliente mc
					inner join ISBlogin lo
						on lo.LGnumero=mc.LGnumero
					
					left join ISBmotivoBloqueo mot
						on mc.MSmotivo = mot.MBmotivo			
				
					inner join ISBproducto p
						on p.Contratoid=lo.Contratoid
				
					inner join ISBcuenta c
						on c.CTid=p.CTid
				
					inner join ISBpersona per
						on per.Pquien=c.Pquien

					inner join ISBagente ag
						on ag.AGid=mc.AGid
							and ag.Ecodigo=per.Ecodigo
					
					inner join ISBpersona perAG
						on perAG.Pquien=ag.Pquien"
		filtro="#filtro# order by nombreAG,LGlogin,CUECUE"
		desplegar="CNsuscriptor,LGlogin,CUECUE,nombreCuenta,MSoperacion,MSfechaCompleto,MBdescripcion,MSsaldo,LGserids,PQcodigo"
		etiquetas="Suscriptor,Logines,Cuenta,Nombre Cuenta,Tipo de Tarea,fecha de Cumplimiento,Motivo de Tarea,Saldo,Inte,Paquete"
		formatos="S,S,I,S,S,DT,S,N,S,S"
		align="left,left,left,left,left,left,left,left,left,left"
		showlink="false"
		formName="form2"
		ajustar="N,N,M,N,N,N,N,N,N,N"
		keys="MSid"
		cortes="nombreAG"
		checkboxes="S"
		botones="Revisado"
		MaxRows="15"
		MaxRowsQuery="150"
		filtrar_automatico="false"
		mostrar_filtro="false"
		irA="mensajesVend-sql.cfm" /> 

<script language="javascript" type="text/javascript">
	<cfoutput>
		VerificarChecks();
		function funcRevisado(){
			<cfif isdefined('url.AGIDP') and url.AGIDP NEQ ''>
				document.form2.AGIDP_F.value = '#url.AGIDP#';
			</cfif>			
			<cfif isdefined('url.PQUIEN') and url.PQUIEN NEQ ''>
				document.form2.PQUIEN_F.value = '#url.PQUIEN#';
			</cfif>					
			<cfif isdefined('url.LGlogin') and url.LGlogin NEQ ''>
				document.form2.LGLOGIN_F.value = '#url.LGlogin#';
			</cfif>		
			<cfif isdefined('url.fechaIni') and url.fechaIni NEQ ''>
				document.form2.FECHAINI_F.value = '#url.fechaIni#';
			</cfif>		
			<cfif isdefined('url.fechaFin') and url.fechaFin NEQ ''>
				document.form2.FECHAFIN_F.value = '#url.fechaFin#';
			</cfif>	
			<cfif isdefined('url.MSoperacion') and url.MSoperacion NEQ '-1'>
				document.form2.MSOPERACION_F.value = '#url.MSoperacion#';
			</cfif>	
			<cfif isdefined('url.MSrevAgente') and url.MSrevAgente NEQ '-1'>
				document.form2.MSREVAGENTE_F.value = '#url.MSrevAgente#';
			</cfif>	
		}
		function VerificarChecks(){
			var estado;
		   for (i=0;i<document.form2.chk.length;i++) {
				estado = eval('document.form2.REVISADOAGENTE_' + ((i==0)?1:i));
		   		if (estado != undefined && estado.value == 'L')
						document.form2.chk[i].disabled = true;
		   	}

		}
	</cfoutput>
</script>