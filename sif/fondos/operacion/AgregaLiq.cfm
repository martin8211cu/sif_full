<cfif isdefined("attributes.C0NSEC") 
  and isdefined("attributes.CJM00COD") 
  and isdefined("attributes.CJX04NUM") 
  and isdefined("attributes.CJX04FEC") 
  and isdefined("attributes.CGE20NOC")
  and isdefined("attributes.CG5CON") 
  and isdefined("attributes.CGTBAT")  
  and isdefined("attributes.CJX04MON")>

  
		<cfscript>
			if (not(isdefined("session.VPrevia"))) 
			{
				session.VPrevia = structnew();
			}
			// Estos son los campos que contiene la estructura
			// 		1.  Consecutivo
			// 		2.  Fondo
			// 		3.  Liquidacion
			// 		4.  Fecha de Liquidacion
			//		5.  Nombre del Encargado de Fondo
			//      6.  Consecutivo de Asiento (SE ELIMINO)
			//      7.  Lote (SE ELIMINO)
			//      8.  Monto

			tempvalue = listtoarray('#attributes.C0NSEC#,#attributes.CJM00COD#,#attributes.CJX04NUM#,#dateformat(attributes.CJX04FEC,"dd/mm/yyyy")#,#attributes.CGE20NOC#,#attributes.CG5CON#,#attributes.CGTBAT#,#attributes.CJX04MON#');
			
			if (not(structKeyExists(session.VPrevia, attributes.C0NSEC))) 
			{
				StructInsert(session.VPrevia,attributes.C0NSEC,tempvalue);
			}			
		</cfscript>
</cfif>