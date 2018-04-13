module MnoEnterprise
  class Jpi::V1::Admin::AppMetricsController < Jpi::V1::Admin::BaseResourceController

    # GET /mnoe/jpi/v1/admin/app_metrics
    def index
      org_ids = current_user.client_ids if current_user.admin_role == 'staff'

      if params[:terms]
        # Search mode
        @app_metrics = []

        if org_ids
          JSON.parse(params[:terms]).map { |t| @app_metrics = @app_metrics | MnoEnterprise::AppMetrics.where(organization_ids: org_ids).where(Hash[*t]) }
        else
          JSON.parse(params[:terms]).map { |t| @app_metrics = @app_metrics | MnoEnterprise::AppMetrics.where(Hash[*t]) }
        end
        response.headers['X-Total-Count'] = @app_metrics.count
      else
        # Index mode
        query = MnoEnterprise::AppMetrics.apply_query_params(params)
        query = query.where(organization_ids: org_ids ) if org_ids.present?
        @app_metrics = query.to_a
        response.headers['X-Total-Count'] = query.meta.record_count
      end
    end

    # GET /mnoe/jpi/v1/admin/app_metrics/1
    def show
      @app_metrics = MnoEnterprise::App.find_one(params[:id])
    end
  end
end
