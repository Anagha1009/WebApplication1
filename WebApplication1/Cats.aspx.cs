using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace WebApplication1
{
    public partial class Cats : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                FillRepeater();
            }
        }

        #region "Get Gender value"
        public string getGender(string Gender)
        {
            if (Gender == "1")
            {
                return "Female";
            }
            else
            {
                return "Male";
            }
        }
        #endregion

        #region "On Click of Add Button"
        protected void BtnAdd_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "$('#myModal').modal({backdrop: 'static', keyboard: false});", true);
        }
        #endregion

        #region "Fetch Data"
        public DataTable FetchData(int RowId)
        {
            try
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["CONSTDB"].ToString());
                SqlCommand SqlComm = new SqlCommand();
                DataTable DT = new DataTable();

                SqlComm.CommandType = CommandType.StoredProcedure;
                SqlComm.CommandText = "stp_Emp_FetchData";

                SqlComm.Parameters.AddWithValue("@Row_Id", RowId);

                SqlComm.Connection = SqlConn;

                if (SqlConn.State == ConnectionState.Closed)
                {
                    SqlConn.Open();
                }

                SqlDataAdapter SqlDA = new SqlDataAdapter(SqlComm);
                SqlDA.Fill(DT);

                if (SqlConn.State == ConnectionState.Open)
                {
                    SqlConn.Close();
                }

                SqlComm.Dispose();
                SqlConn.Dispose();

                return DT;
            }
            catch (Exception ex) { throw ex; }
        }
        #endregion

        #region "Fill Employee Repeater"
        public void FillRepeater()
        {
            DataTable DT = FetchData(0);

            if ((DT != null) && (DT.Rows.Count > 0))
            {
                RptrCats.DataSource = DT;
                RptrCats.DataBind();
            }
            else
            {
                RptrCats.DataSource = null;
                RptrCats.DataBind();
            }
        }
        #endregion
    }
}