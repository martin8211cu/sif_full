<script>	
	var win = null;
	function newWindow(mypage,myname,w,h,features) 
	{
		  var winl = (screen.width-w)/2;
		  var wint = (screen.height-h)/2;
		  if (winl < 0) winl = 0;
		  if (wint < 0) wint = 0;
		  var settings = 'height=' + h + ',';
		  settings += 'width=' + w + ',';
		  settings += 'top=' + wint + ',';
		  settings += 'left=' + winl + ',';
		  settings += features;
		  win = window.open(mypage,myname,settings);
		  win.window.focus();
	}
</script>

<cfif form.VTPrevia eq 0>
	
	
	<!--- Se Genera la referencia que se va a asignar --->
	<cftry>


		<cfquery datasource="#session.Fondos.dsn#" name="NuevaRef">
			set nocount on 
				
			exec sp_RetornaReferencia
				@usuario = '#session.usuario#'
				
			set nocount off 
		</cfquery>
			
		<cfcatch type="any">
			<cftransaction action="rollback"/>
			<script language="JavaScript">
				var  mensaje = new String("<cfoutput>#trim(cfcatch.Detail)#</cfoutput>");
				mensaje = mensaje.substring(40,300)
				alert(mensaje)
				history.back()
			</script>
			<cfabort>
		</cfcatch>
		
	</cftry>		
			
	<cfset ReferenciaGen = NuevaRef.ReferenciaFinal>
	
	<cftransaction>
	<cftry>
		<!--- Se Recorren las Liquidaciones Marcadas --->
		<cfset fechahoy = dateformat(NOW(),"yyyymmdd")>
		
		<cfquery datasource="#session.Fondos.dsn#">
			UPDATE CJX004 
			SET CJX04REF2 ='#ReferenciaGen#' , 
				CJX04FRD ='#fechahoy#' , 
				CJX04URD ='#session.usuario#',
				CJX04IND = 'N' 
			WHERE CJX04IND = 'S'
			  AND CJX04REF2 is null
			  AND CJX04UMK = '#session.usuario#'
			
				<!---   CJM00COD ='#fondo#' 
			  AND CJX04NUM =#liquidacion# --->
		</cfquery>		
		
		<!--- 
		<cfloop list="#DCM#" delimiters="," index="valor">
		
			<!--- Se separa el fondo de la relacion --->
			<cfset pos = #find("-",valor,1)#>
			<cfif pos neq 0>
			
				<cfset fondo=#Mid(valor,1,pos-1)#>
				<cfset liquidacion=#Mid(valor,pos+1,len(valor))#>
				
				<cfquery datasource="#session.Fondos.dsn#">
					UPDATE CJX004 
						SET CJX04REF2 ='#ReferenciaGen#' , 
							CJX04FRD ='#fechahoy#' , 
							CJX04URD ='#session.usuario#',
							CJX04IND = 'N' 
					WHERE CJM00COD ='#fondo#' 
					  AND CJX04NUM =#liquidacion#
				</cfquery>
			
			</cfif>
			
		</cfloop> --->
	
		<cfcatch type="any">
			<cftransaction action="rollback"/>
			<script language="JavaScript">
				var  mensaje = new String("<cfoutput>#trim(cfcatch.Detail)#</cfoutput>");
				mensaje = mensaje.substring(40,300)
				alert(mensaje)
				history.back()
			</script>
			<cfabort>
		</cfcatch>
		
	</cftry>
	<cftransaction action="commit"/>
	</cftransaction>
	
	<!--- Se genera la Caratula 
	<cfinclude template="cjc_CaratulaReferencias.cfm">
	--->
	<cfoutput>
	<script>
	newWindow('cjc_CaratulaReferencias.cfm?soloconsulta=1&ReferenciaGen=#ReferenciaGen#','','700','500','resizable,scrollbars');
	document.location = 'cjc_Referencias.cfm?aplcolor=FFFF33';
	</script>
	</cfoutput>

<cfelse>
	
	<!--- Referencia --->
	
	<cftry>

		<cfquery name="rs" datasource="#session.Fondos.dsn#">
			set nocount on 
			
			exec sp_RetornaReferenciaPrevio
					@usuario = '#session.usuario#'
	
			set nocount off 	
		</cfquery>
	
		<cfcatch type="any">
			<cftransaction action="rollback"/>
			<script language="JavaScript">
				<cfset errorgen = replace(trim(cfcatch.Detail),'"','')>
				<cfset mensajecf = Mid(errorgen,41,300)>
				var  mensaje = new String("<cfoutput>#mensajecf#</cfoutput>");
				//mensaje = mensaje.substring(40,300)
				alert(mensaje)
				history.back()
			</script>
			<cfabort>
		</cfcatch>
		
	</cftry>	
	
	<cfif rs.Periodo neq "">
	
		<cfset RELFINAL = rs.Periodo & "-XX">
		<cfif isdefined("session.VPrevia")>
			<cfscript>StructClear(session.VPrevia);</cfscript>
		</cfif>
		
		<!--- Se Recorren las Liquidaciones Marcadas --->
		<cfset fechahoy = dateformat(NOW(),"yyyymmdd")>
		<cfset contador=1>		
				
		<cfquery name="info" datasource="#session.Fondos.dsn#">
		<!---
		Select distinct A.CJM00COD, A.CJX04NUM, A.CJX04FEC, C.CGE20NOC, 
						B.CG5CON,   B.CGTBAT,  (isnull(A.CJX04MON,0) + isnull(A.CJX04TGT,0)) Total
		from CJX004 A, CGT003 B, CGE020 C
		where A.INTBAT = B.INTBAT
		  AND A.CJX04URF = C.CGE20NOL
		  AND A.CJX04IND = 'S'
		  AND A.CJX04REF2 is null
		  AND CJX04UMK = '#session.usuario#'
		Order by convert(int, A.CJM00COD), A.CJX04NUM,B.CG5CON, B.CGTBAT
		--->
		<!--- AND CJM00COD ='#fondo#'
		      AND CJX04NUM =#liquidacion# --->


		Select distinct A.CJM00COD, A.CJX04NUM, A.CJX04FEC, C.CGE20NOC,
				case when B.CG5CON is null then 'N/A' else convert(varchar,B.CG5CON) end as CG5CON,
				case when B.CGTBAT is null then 'N/A' else convert(varchar,B.CGTBAT) end as CGTBAT,
				(isnull(A.CJX04MON,0) + isnull(A.CJX04TGT,0)) Total
		from CJX004 A
			left join CGT003 B
				on A.INTBAT = B.INTBAT
			inner join CGE020 C
				on A.CJX04URF = C.CGE20NOL

		where A.CJX04IND = 'S'
		  AND A.CJX04REF2 is null
		  AND CJX04UMK = '#session.usuario#'
		Order by convert(int, A.CJM00COD), A.CJX04NUM,B.CG5CON, B.CGTBAT
		</cfquery>
								
		<cfoutput query="info">
			
			<cf_AgregaLiq 
				C0NSEC = "#contador#"
				CJM00COD = "#info.CJM00COD#"
				CJX04NUM = "#info.CJX04NUM#"
				CJX04FEC = "#info.CJX04FEC#"
				CGE20NOC = "#info.CGE20NOC#"
				CG5CON = "#info.CG5CON#"
				CGTBAT = "#info.CGTBAT#"
				CJX04MON = "#info.Total#"
			> 
			<cfset contador=contador + 1>	
		</cfoutput>
				
		
		<cfoutput>
		<script>
		newWindow('cjc_CaratulaReferencias.cfm?VTPrevia=1&ReferenciaGen=#RELFINAL#','','700','500','resizable,scrollbars');
		document.location = 'cjc_Referencias.cfm?vprcol=FFFF33';
		</script>
		</cfoutput>	
	
	</cfif>
	
</cfif>
