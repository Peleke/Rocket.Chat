import { Logger } from '@rocket.chat/logger';
import { useEndpoint } from '@rocket.chat/ui-contexts';
import { useMutation } from '@tanstack/react-query';

const logger = new Logger('Telemetry');

export const useSendTelemetryMutation = () => {
	const sendTelemetry = useEndpoint('POST', '/v1/statistics.telemetry');

	return useMutation({
		mutationFn: sendTelemetry,
		onError: (error) => {
			logger.warn(error);
		},
	});
};
