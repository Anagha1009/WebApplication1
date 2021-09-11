using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;

namespace WebApplication1
{
    public partial class Employee : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                FillRepeater();
            }
        }

        #region "On Click of Save Button"
        protected void BtnSave_Click(object sender, EventArgs e)
        {
            DataTable DT = ValidateInsert(TxtEmail.Text, TxtMobile.Text, TxtPAN.Text, TxtPassport.Text);

            if ((DT != null) && (DT.Rows.Count > 0))
            {
                if ((DT.Rows[0]["Email"].ToString() != TxtEmail.Text.ToLower()) && (DT.Rows[0]["Mobile"].ToString() != TxtMobile.Text) && (DT.Rows[0]["Pan"].ToString() != TxtPAN.Text.ToUpper()) && (DT.Rows[0]["Passport"].ToString() != TxtPassport.Text.ToUpper()))
                {
                    if (InsertData())
                    {
                        FillRepeater();
                        Clear();
                        Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal('Success','Your record has been inserted successfully!','success')", true);
                    }
                    else
                    {
                        Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal('Error','Your record cannot be inserted. Please try again!','error')", true);
                    }
                }
                else
                {
                    if (DT.Rows[0]["Email"].ToString() == TxtEmail.Text.ToLower())
                    {
                        Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal({title: 'Failed!',text: 'This Email is already been used!',type: 'error'}).then(function() {$('#myModal').modal({backdrop: 'static', keyboard: false})})", true);
                    }
                    else if (DT.Rows[0]["Mobile"].ToString() == TxtMobile.Text)
                    {
                        Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal({title: 'Failed!',text: 'This Mobile Number is already been used!',type: 'error'}).then(function() {$('#myModal').modal({backdrop: 'static', keyboard: false})})", true);
                    }
                    else if (DT.Rows[0]["Pan"].ToString() == TxtPAN.Text.ToUpper())
                    {
                        Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal({title: 'Failed!',text: 'This PAN Number is already been used!',type: 'error'}).then(function() {$('#myModal').modal({backdrop: 'static', keyboard: false})})", true);
                    }
                    else if (DT.Rows[0]["Passport"].ToString() == TxtPassport.Text.ToUpper())
                    {
                        Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal({title: 'Failed!',text: 'This Passport Number is already been used!',type: 'error'}).then(function() {$('#myModal').modal({backdrop: 'static', keyboard: false})})", true);
                    }
                }
            }
            else
            {
                Clear();
                Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal('Error','Your record cannot be inserted. Please try again!','error')", true);
            }

        }
        #endregion

        #region "Insert Data"
        public bool InsertData()
        {
            bool FunctionReturnValue = false;
            try
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["CONSTDB"].ToString());
                SqlCommand SqlComm = new SqlCommand();

                SqlComm.CommandType = CommandType.StoredProcedure;
                SqlComm.CommandText = "stp_Emp_InsertData";

                SqlComm.Parameters.AddWithValue("@FirstName", TxtFirstName.Text);
                SqlComm.Parameters.AddWithValue("@LastName", TxtLastName.Text);
                SqlComm.Parameters.AddWithValue("@CountryId", HFCountry.Value == "-1" ? 0 : Convert.ToInt32(HFCountry.Value.ToString()));
                SqlComm.Parameters.AddWithValue("@StateId", HFState.Value == "-1" ? 0 : Convert.ToInt32(HFState.Value.ToString()));
                SqlComm.Parameters.AddWithValue("@CityId", HFCity.Value == "-1" ? 0 : Convert.ToInt32(HFCity.Value.ToString()));
                SqlComm.Parameters.AddWithValue("@EmailAddress", TxtEmail.Text.ToLower());
                SqlComm.Parameters.AddWithValue("@MobileNumber", TxtMobile.Text);
                SqlComm.Parameters.AddWithValue("@PanNumber", TxtPAN.Text.ToUpper());
                SqlComm.Parameters.AddWithValue("@PassportNumber", TxtPassport.Text.ToUpper());
                SqlComm.Parameters.AddWithValue("@Gender", Convert.ToInt32(RdbtnGender.SelectedValue.ToString()));
                SqlComm.Parameters.AddWithValue("@IsActive", Convert.ToBoolean(ChckIsActive.Checked));

                DateTime dateDOB = DateTime.Parse(TxtDOB2.Text);
                SqlComm.Parameters.AddWithValue("@DateOfBirth", dateDOB);

                if (!String.IsNullOrEmpty(TxtDOJ2.Text))
                {
                    DateTime dateDOJ = DateTime.Parse(TxtDOJ2.Text);
                    SqlComm.Parameters.AddWithValue("@DateOfJoinee", dateDOJ);
                }

                HttpPostedFile postedFile = FUProfileImg.PostedFile;
                string FileExtension = Path.GetExtension(Path.GetFileName(postedFile.FileName));
                string FileName = "Employee_" + TxtPAN.Text.ToUpper() + "_" + Path.GetFileName(postedFile.FileName);
                decimal size = Math.Round(((decimal)FUProfileImg.PostedFile.ContentLength / (decimal)1024), 2);

                if (FUProfileImg.HasFile)
                {
                    if ((FileExtension.ToLower() == ".jpg" || FileExtension.ToLower() == ".png") && (size < 200))
                    {
                        FUProfileImg.SaveAs(Server.MapPath("/Uploads/Employee/" + FileName));
                        SqlComm.Parameters.AddWithValue("@ProfileImage", FileName);
                    }
                    else
                    {
                        Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal({title: 'Failed!',text: 'Your file should be in .jpg, .png format and file size should be less than 200 kb!',type: 'error'}).then(function() {$('#myModal').modal({backdrop: 'static', keyboard: false})})", true);
                        return FunctionReturnValue = false;
                    }
                }

                SqlComm.Connection = SqlConn;

                if (SqlConn.State == ConnectionState.Closed)
                {
                    SqlConn.Open();
                }

                SqlComm.ExecuteNonQuery();

                if (SqlConn.State == ConnectionState.Open)
                {
                    SqlConn.Close();
                }

                SqlComm.Dispose();
                SqlConn.Dispose();

                FunctionReturnValue = true;
            }
            catch (Exception ex) { throw ex; }

            return FunctionReturnValue;
        }
        #endregion

        #region "Fill Employee Repeater"
        public void FillRepeater()
        {
            DataTable DT = FetchData(0);

            if ((DT != null) && (DT.Rows.Count > 0))
            {
                RptrEmployee.DataSource = DT;
                RptrEmployee.DataBind();
            }
            else
            {
                RptrEmployee.DataSource = null;
                RptrEmployee.DataBind();
            }
        }
        #endregion

        #region "Clear Form"
        public void Clear()
        {
            TxtFirstName.Text = "";
            TxtLastName.Text = "";
            TxtEmail.Text = "";
            TxtPAN.Text = "";
            TxtPassport.Text = "";
            TxtDOB2.Text = "";
            TxtDOJ2.Text = "";
            TxtMobile.Text = "";
            RdbtnGender.SelectedItem.Selected = false;
            RdbtnGender.Items.FindByValue("0").Selected = true;
            if (ChckIsActive.Checked) { ChckIsActive.Checked = false; }
            HFExisCountry.Value = "";
            HFExisState.Value = "";
            HFExisCity.Value = "";
        }
        #endregion

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

        #region "Get IsActive Value"
        public string getIsActive(string IsActive)
        {
            if (IsActive.ToLower() == "true")
            {
                return "Yes";
            }
            else
            {
                return "No";
            }
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

        #region "Display Data in Edit Form"
        public void DisplayData(int RowId)
        {
            DataTable DT = FetchData(RowId);

            if ((DT != null) && (DT.Rows.Count > 0))
            {
                TxtFirstName.Text = DT.Rows[0]["FirstName"].ToString();
                TxtLastName.Text = DT.Rows[0]["LastName"].ToString();
                TxtEmail.Text = DT.Rows[0]["EmailAddress"].ToString();
                TxtMobile.Text = DT.Rows[0]["MobileNumber"].ToString();
                TxtPAN.Text = DT.Rows[0]["PanNumber"].ToString();
                TxtPassport.Text = DT.Rows[0]["PassportNumber"].ToString();
                TxtDOB2.Text = Convert.ToDateTime(DT.Rows[0]["DateOfBirth"]).ToShortDateString();

                if (!String.IsNullOrEmpty((DT.Rows[0]["DateOfJoinee"]).ToString()))
                {
                    TxtDOJ2.Text = Convert.ToDateTime(DT.Rows[0]["DateOfJoinee"]).ToShortDateString();
                }                
                HFExisCountry.Value = DT.Rows[0]["CountryId"].ToString();
                HFExisState.Value = DT.Rows[0]["StateId"].ToString();
                HFExisCity.Value = DT.Rows[0]["CityId"].ToString();
                RdbtnGender.SelectedItem.Selected = false;
                RdbtnGender.Items.FindByValue(DT.Rows[0]["Gender"].ToString()).Selected = true;
                ChckIsActive.Checked = false;
                if (DT.Rows[0]["IsActive"].ToString().ToLower() == "true")
                {
                    ChckIsActive.Checked = true;
                }

            }
        }
        #endregion

        #region "On Click of Update Button"
        protected void BtnUpdate_Click(object sender, EventArgs e)
        {
            DataTable DT = ValidateUpdate(Convert.ToInt32(HFRowId.Value), TxtEmail.Text, TxtMobile.Text, TxtPAN.Text, TxtPassport.Text);

            if ((DT != null) && (DT.Rows.Count > 0))
            {
                if ((DT.Rows[0]["Email"].ToString() != TxtEmail.Text.ToLower()) && (DT.Rows[0]["Mobile"].ToString() != TxtMobile.Text) && (DT.Rows[0]["Pan"].ToString() != TxtPAN.Text.ToUpper()) && (DT.Rows[0]["Passport"].ToString() != TxtPassport.Text.ToUpper()))
                {
                    if (UpdateData(Convert.ToInt32(HFRowId.Value)))
                    {
                        FillRepeater();
                        Clear();
                        Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal('Success','Your record has been updated successfully!','success')", true);
                    }
                    else
                    {
                        Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal('Error','Your record cannot be updated. Please try again!','error')", true);
                    }
                }
                else
                {
                    if (DT.Rows[0]["Email"].ToString() == TxtEmail.Text.ToLower())
                    {
                        DisplayData(Convert.ToInt32(HFRowId.Value));
                        Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal({title: 'Failed!',text: 'This Email is already been used!',type: 'error'}).then(function() {$('#myModal').modal({backdrop: 'static', keyboard: false})})", true);
                    }
                    else if (DT.Rows[0]["Mobile"].ToString() == TxtMobile.Text)
                    {
                        DisplayData(Convert.ToInt32(HFRowId.Value));
                        Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal({title: 'Failed!',text: 'This Mobile Number is already been used!',type: 'error'}).then(function() {$('#myModal').modal({backdrop: 'static', keyboard: false})})", true);
                    }
                    else if (DT.Rows[0]["Pan"].ToString() == TxtPAN.Text.ToUpper())
                    {
                        DisplayData(Convert.ToInt32(HFRowId.Value));
                        Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal({title: 'Failed!',text: 'This PAN Number is already been used!',type: 'error'}).then(function() {$('#myModal').modal({backdrop: 'static', keyboard: false})})", true);
                    }
                    else if (DT.Rows[0]["Passport"].ToString() == TxtPassport.Text.ToUpper())
                    {
                        DisplayData(Convert.ToInt32(HFRowId.Value));
                        Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal({title: 'Failed!',text: 'This Passport Number is already been used!',type: 'error'}).then(function() {$('#myModal').modal({backdrop: 'static', keyboard: false})})", true);
                    }
                }
            }
            else
            {
                Clear();
                Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal('Error','Your record cannot be updated. Please try again!','error')", true);
            }

        }
        #endregion

        #region "Update Data"
        public bool UpdateData(int RowId)
        {
            bool FunctionReturnValue = false;
            try
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["CONSTDB"].ToString());
                SqlCommand SqlComm = new SqlCommand();

                SqlComm.CommandType = CommandType.StoredProcedure;
                SqlComm.CommandText = "stp_Emp_UpdateData";

                SqlComm.Parameters.AddWithValue("@Row_Id", RowId);
                SqlComm.Parameters.AddWithValue("@FirstName", TxtFirstName.Text);
                SqlComm.Parameters.AddWithValue("@LastName", TxtLastName.Text);
                SqlComm.Parameters.AddWithValue("@CountryId", Convert.ToInt32(HFUpdatedCountry.Value));
                SqlComm.Parameters.AddWithValue("@StateId", Convert.ToInt32(HFUpdatedState.Value));
                SqlComm.Parameters.AddWithValue("@CityId", Convert.ToInt32(HFUpdatedCity.Value));
                SqlComm.Parameters.AddWithValue("@EmailAddress", TxtEmail.Text.ToLower());
                SqlComm.Parameters.AddWithValue("@MobileNumber", TxtMobile.Text);
                SqlComm.Parameters.AddWithValue("@PanNumber", TxtPAN.Text.ToUpper());
                SqlComm.Parameters.AddWithValue("@PassportNumber", TxtPassport.Text.ToUpper());
                SqlComm.Parameters.AddWithValue("@Gender", Convert.ToInt32(RdbtnGender.SelectedValue.ToString()));
                SqlComm.Parameters.AddWithValue("@IsActive", Convert.ToBoolean(ChckIsActive.Checked));
                DateTime dateDOB = DateTime.Parse(TxtDOB2.Text);
                SqlComm.Parameters.AddWithValue("@DateOfBirth", dateDOB);

                if (!String.IsNullOrEmpty(TxtDOJ2.Text))
                {
                    DateTime dateDOJ = DateTime.Parse(TxtDOJ2.Text);
                    SqlComm.Parameters.AddWithValue("@DateOfJoinee", dateDOJ);
                }

                HttpPostedFile postedFile = FUProfileImg.PostedFile;
                string FileExtension = Path.GetExtension(Path.GetFileName(postedFile.FileName));
                string FileName = "Employee_" + TxtPAN.Text.ToUpper() + "_" + Path.GetFileName(postedFile.FileName);
                decimal size = Math.Round(((decimal)FUProfileImg.PostedFile.ContentLength / (decimal)1024), 2);

                if (FUProfileImg.HasFile)
                {
                    if ((FileExtension.ToLower() == ".jpg" || FileExtension.ToLower() == ".png") && (size < 200))
                    {
                        DeleteImage(FileName);
                        FUProfileImg.SaveAs(Server.MapPath("/Uploads/Employee/" + FileName));
                        SqlComm.Parameters.AddWithValue("@ProfileImage", FileName);
                    }
                    else
                    {
                        DisplayData(Convert.ToInt32(HFRowId.Value));
                        Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal({title: 'Failed!',text: 'Your file should be in .jpg, .png format and file size should be less than 200 kb!',type: 'error'}).then(function() {$('#myModal').modal({backdrop: 'static', keyboard: false})})", true);
                        return FunctionReturnValue = false;
                    }
                }
                else
                {
                    string path = Server.MapPath(HFExisImage.Value);

                    FileInfo file = new FileInfo(path);

                    if (file.Exists)
                    {
                        file.Delete();
                    }
                }
                
                SqlComm.Connection = SqlConn;

                if (SqlConn.State == ConnectionState.Closed)
                {
                    SqlConn.Open();
                }

                SqlComm.ExecuteNonQuery();

                if (SqlConn.State == ConnectionState.Open)
                {
                    SqlConn.Close();
                }

                SqlComm.Dispose();
                SqlConn.Dispose();

                FunctionReturnValue = true;
            }
            catch (Exception ex) { throw ex; }

            return FunctionReturnValue;
        }
        #endregion

        #region "Delete Data"
        public bool DeleteData(int RowId)
        {
            bool FunctionReturnValue = false;
            try
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["CONSTDB"].ToString());
                SqlCommand SqlComm = new SqlCommand();

                SqlComm.CommandType = CommandType.StoredProcedure;
                SqlComm.CommandText = "stp_Emp_DeleteData";

                SqlComm.Parameters.AddWithValue("@Row_Id", RowId);

                SqlComm.Connection = SqlConn;

                if (SqlConn.State == ConnectionState.Closed)
                {
                    SqlConn.Open();
                }

                SqlComm.ExecuteNonQuery();

                if (SqlConn.State == ConnectionState.Open)
                {
                    SqlConn.Close();
                }

                SqlComm.Dispose();
                SqlConn.Dispose();

                FunctionReturnValue = true;
            }
            catch (Exception ex) { throw ex; }

            return FunctionReturnValue;
        }
        #endregion

        #region "Validate Insert"
        public DataTable ValidateInsert(string Email, string Mobile, string Pan, string Passport)
        {
            try
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["CONSTDB"].ToString());
                SqlCommand SqlComm = new SqlCommand();
                DataTable DT = new DataTable();

                SqlComm.CommandType = CommandType.StoredProcedure;
                SqlComm.CommandText = "stp_Emp_ValidateInsert";

                SqlComm.Parameters.AddWithValue("@EmailAddress", Email.ToLower());
                SqlComm.Parameters.AddWithValue("@MobileNumber", Mobile);
                SqlComm.Parameters.AddWithValue("@PanNumber", Pan.ToUpper());
                SqlComm.Parameters.AddWithValue("@PassportNumber", Passport.ToUpper());

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

                DT.Dispose();
                SqlComm.Dispose();
                SqlConn.Dispose();

                return DT;
            }
            catch (Exception ex) { throw ex; }
        }
        #endregion

        #region "Validate Update"
        public DataTable ValidateUpdate(int RowId, string Email, string Mobile, string Pan, string Passport)
        {
            try
            {
                SqlConnection SqlConn = new SqlConnection(ConfigurationManager.ConnectionStrings["CONSTDB"].ToString());
                SqlCommand SqlComm = new SqlCommand();
                DataTable DT = new DataTable();

                SqlComm.CommandType = CommandType.StoredProcedure;
                SqlComm.CommandText = "stp_Emp_ValidateUpdate";

                SqlComm.Parameters.AddWithValue("@Row_Id", RowId);
                SqlComm.Parameters.AddWithValue("@EmailAddress", Email.ToLower());
                SqlComm.Parameters.AddWithValue("@MobileNumber", Mobile);
                SqlComm.Parameters.AddWithValue("@PanNumber", Pan.ToUpper());
                SqlComm.Parameters.AddWithValue("@PassportNumber", Passport.ToUpper());

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

                DT.Dispose();
                SqlComm.Dispose();
                SqlConn.Dispose();

                return DT;
            }
            catch (Exception ex) { throw ex; }
        }
        #endregion

        #region "On Row Command of Employee Repeater"
        protected void RptrEmployee_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                HFRowId.Value = "";
                HFRowId.Value = e.CommandArgument.ToString();
                DisplayData(Convert.ToInt32(e.CommandArgument.ToString()));
                BtnUpdate.Visible = true;
                BtnSave.Visible = false;

                //Image ImgProfile = (Image)(RptrEmployee.Items[0].FindControl("ImgProfile"));
                HFExisImage.Value = (e.Item.FindControl("ImgProfile") as Image).ImageUrl;

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "$('#myModal').modal({backdrop: 'static', keyboard: false});", true);
            }
            else if (e.CommandName == "Delete")
            {
                if (DeleteData(Convert.ToInt32(e.CommandArgument.ToString())))
                {
                    FillRepeater();
                    Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal('Success','Your record has been deleted successfully!','success')", true);
                }
                else
                {
                    Page.ClientScript.RegisterStartupScript(GetType(), "message", "swal('Error','Your record cannot be deleted. Please try again!','error')", true);
                }
            }
        }
        #endregion

        #region "On Row Data Bound of Employee Repeater"
        protected void RptrEmployee_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Image ImgProfile = (Image)e.Item.FindControl("ImgProfile");
                Label LblNoImage = (Label)e.Item.FindControl("LblNoImage");

                if (DataBinder.Eval(e.Item.DataItem, "ProfileImage").ToString() != "")
                {
                    ImgProfile.Visible = true;
                    LblNoImage.Visible = false;
                }
                else
                {
                    ImgProfile.Visible = false;
                    LblNoImage.Visible = true;                    
                }
            }

        }
        #endregion

        #region "On Click of Add Button"
        protected void BtnAdd_Click(object sender, EventArgs e)
        {
            Clear();
            BtnSave.Visible = true;
            BtnUpdate.Visible = false;
            BtnUpdate.Visible = false;           
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "$('#myModal').modal({backdrop: 'static', keyboard: false});", true);
        }
        #endregion

        #region "Delete Image from Folder"
        public void DeleteImage(string FileName)
        {
            string path = Server.MapPath("/Uploads/Employee/" + FileName);
            FileInfo file = new FileInfo(path);

            if (file.Exists)  
            {
                file.Delete();
            }
        }
        #endregion
    }
}